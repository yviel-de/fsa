# drone starlark configuration to test and publish yviel's fsa
# public mirror: github.com/yviel-de/fsa
# keep in mind that this is just dynamic templating that returns drone yaml

# NOTE:
# the following values can be set manually to start a build for another branch
# shells = "true"
# scenario = "$scenarioname" or "all"
# platform = "$platformname" or "all"
# docs = "true"

def main(ctx):
    #### SETTINGS START
    # shells to test against
    shells = [
#       "sh",
#       "dash",
#       "ksh",
        "bash",
    ]
    # molecule scenarios to run
    scenarios = [
        "nochange",
        "apps",
        "base",
        "net",
        "web",
        "mail",
    ]
    # molecule platforms to test against
    platforms = [
        "obsd73",
    ]
    #### SETTINGS END

    #### GIT LOGIC START
    # set some handy vars
    branch = ctx.build.target
    event = ctx.build.event
    commit = ctx.build.commit
    title = ctx.build.title

    if branch != "master" and event == "custom":
        # we were triggered manually, run with conditionals, don't push
        return pipelines_all(shells, scenarios, platforms, commit, cond=True)

    elif branch == "master" and event == "pull_request":
        # open PR from any to master, run all but don't push
        return pipelines_all(shells, scenarios, platforms, commit, cond=False, push="stage")

    elif branch == "master" and (event == "push" or event == "custom"):
        # push to master, run all tests and push
        return pipelines_all(shells, scenarios, platforms, commit, cond=False, push="prod")

    else:
        return pipeline_usage()
    #### GIT LOGIC END

# just a logical grouping of all test pipelines to make the main function's logic more readable
def pipelines_all(shells, scenarios, platforms, commit, push="", cond=False):
    pipelines = []
    # run misc tests
    pipelines.append(other_tests(cond))

# not written yet
#    # run shell tests
#    for shell in shells:
#        pipelines.append(shell_tests(shell, cond))

    # run molecule tests
    pipelines.append(molecule_prep(commit, scenarios, all_platforms=platforms, cond=cond))
    moleculepipes = []
    for platform in platforms:
        pipelines.append(molecule_tests(scenarios, platform, commit, cond))
        moleculepipes.append("molecule-%s" % platform)
    pipelines.append(molecule_cleanup(commit, platforms, depends=moleculepipes))

    if push:
        # build pipeline dependencies and push
        push_deps = []
        if push == "prod":
            for pipeline in pipelines:
                push_deps.append(pipeline["name"])
        # push to staging, and maybe prod
        pipelines.append(push_fsa(push, "kane-key", push_deps))

    return pipelines

# basic pipeline definition
def pipeline_wrapper(name, steps, depends=[], type="docker", clone=True, trigger={}):
    pipeline_object = {
        "kind": "pipeline",
        "type": type,
        "name": "%s" % name,
        "platform": {
            # running on raspi4 cluster
            "arch": "arm64",
        },
        "steps": steps,
    }

    # hardcoded build box creds, see playbooks/vagrant.yml
    sshserver = {
        "host": "vagrant",
        "user": "vagrant",
        "ssh_key": {
            "from_secret": "kane-key",
        }
    }

    if not clone:
        pipeline_object.update([("clone", {"disable": True})])
    if len(depends) > 0:
        pipeline_object.update([("depends_on", depends)])
    if type == "ssh":
        pipeline_object.update([("server", sshserver)])
    if trigger != {}:
        pipeline_object.update([("trigger", trigger)])

    return pipeline_object

# basic step definition
def step_wrapper(name, commands, depends=[], environment={}, image=None):
    step_object = {
            "name": name,
            "commands": commands
        }

    # no image for when type is ssh
    if image:
        step_object.update([("image", image)])
    if depends != []:
        step_object.update([("depends_on", depends)])
    if environment != {}:
        step_object.update([("environment", environment)])

    return step_object

# miscellaneous non-molecule non-shell tests here
def other_tests(cond=True):
    commands = ['sh utils/build-fsa.sh doit docstests', 'sh utils/docs-fsa.sh all']
    if cond:
        commands.insert(0, '[ "$docs" != "true" ] && echo -n "\nBUILD SKIPPED" && exit 0')

    steps = [step_wrapper("test-docs", commands, image="alpine")]
    return pipeline_wrapper("other-tests", steps)

# perform tests against the main fsa.sh shellscript
def shell_tests(shell, cond=True):
    # todo: shell tests
    commands = ['%s utils/fsa.sh' % shell]
    if cond:
        commands.insert(0, '[ "$shells" != "true" ] && echo -n "\nBUILD SKIPPED" && exit 0')

    steps = [step_wrapper("TODO: write tests", commands, image="registry.opviel.de:80/fsa-build")]
    pipename = "shell-tests-%s" % shell
    return pipeline_wrapper(pipename, steps)

def molecule_prep(commit, scenarios, all_platforms, cond=True):
    commands = [
        "for i in $PIPENV_CACHE_DIR $WORKON_HOME; do [ ! -d $i ] && mkdir -p $i; done",
        "echo $WORKON_HOME > .venv",
        'bash -x utils/install-fsa.sh please --dev'
    ]
    if cond:
        # we join() the list elements so we can grep across the string
        commands.insert(0, '[ "$platform" != "all" ] && echo "%s" | grep -vwq "$platform" && echo -n "\nBUILD SKIPPED" && exit 0' % " ".join(all_platforms))
        commands.insert(1, '[ "$scenario" != "all" ] && [ ! -d "molecule/$scenario" ] && echo -n "\nBUILD SKIPPED" && exit 0')

    environment = {
        "PIPENV_CACHE_DIR": "/home/vagrant/.cache/pipenv",
        "WORKON_HOME": "/tmp/drone-pipenv-%s/venv" % commit,
    }

    steps = [step_wrapper("install-fsa", commands, environment=environment)]
    return pipeline_wrapper("molecule-prep", steps, type="ssh")

# iterates through all scenarios and outputs a pipeline
def molecule_tests(scenarios, platform, commit, cond=True):
    steps = []
    environment = {
        "PIPENV_CACHE_DIR": "/home/vagrant/.cache/pipenv",
        "WORKON_HOME": "/tmp/drone-pipenv-%s/venv" % commit,
        "VAGRANT_HOME": "/home/vagrant/.vagrant.d",
    }
    for scenario in scenarios:
        commands = [
            "echo $WORKON_HOME > .venv",
            'bash utils/test-fsa.sh test %s --virthost seth --boxname %s' % (scenario, platform)
        ]
        if cond:
            commands.insert(0, '[ "$platform" != "all" ] && [ "$platform" != "%s" ] && echo -n "\nBUILD SKIPPED" && exit 0' % platform)
            commands.insert(1, '[ "$scenario" != "all" ] && [ "$scenario" != "%s" ] && echo -n "\nBUILD SKIPPED" && exit 0' % scenario)
        stepname = "scenario-%s" % scenario
        steps.append(step_wrapper(stepname, commands, environment=environment))

    pipename = "molecule-%s" % platform
    return pipeline_wrapper(pipename, steps, depends=["molecule-prep"], type="ssh")

def molecule_cleanup(commit, platforms, depends):
    # we should clean up the tmpdir we created, it gets quite big
    steps = [step_wrapper("cleanup", ["rm -rf /tmp/drone-pipenv-%s" % commit])]
    trigger = {
        "status": ["failure", "success"]
    }
    return pipeline_wrapper("molecule-cleanup", steps, depends, type="ssh", trigger=trigger, clone=False)

# push fsa to to an ssh remote, staging and maybe prod
def push_fsa(push, keyname, depends):
    environment = {
        "deploy": {
            "from_secret": keyname
        }
    }
    basecommands = [
        # get the privkey from drone
        "mkdir ~/.ssh",
        'echo "$deploy" > ~/.ssh/id_rsa',
        "chmod 0600 ~/.ssh/id_rsa",
        # build fsa
        "sh -x utils/build-fsa.sh doit",
    ]
    stgcommands = basecommands + [
        # publish to staging
        "export reponame='fsa-staging'",
        "export remotename='ssh://gitea@vcs.opviel.de:2223/fsa'",
        "sh -x utils/push-fsa.sh --fsa",
    ]
    prdcommands = basecommands + [
        # publish to prod
        "export reponame='fsa'",
        "export remotename='git@github.com:yviel-de'",
        "bash -x utils/push-fsa.sh --fsa"
    ]
    steps = [
        step_wrapper("build-push-stage", stgcommands, environment=environment, image="registry.opviel.de:80/fsa-build"),
    ]
    if push == "prod":
        steps.append(step_wrapper("push-prod", prdcommands, environment=environment, image="registry.opviel.de:80/fsa-build"))
    return pipeline_wrapper("build-push-fsa", steps, depends)

# dummy pipeline to run when there is nothing to do
def pipeline_usage():
    message = '''
###########################################
## No build: not on master branch, not triggered manually
##
## USAGE:
## Autobuilds only for manual build or push/MR to master.
## Manually start a build for your own branch through the GUI.
##
## The following parameters are available:
## "shells"   = "true" to run shell tests
## "scenario" = "name" or "all" to test specific scenarios
## "platform" = "name" or "all" to run tests on specific platforms
## "docs"     = "true" to run documentation tests
'''

    commands = [
        'echo -e "%s"' % message
    ]
    steps = [step_wrapper("usage", commands, image="alpine")]
    return pipeline_wrapper("usage", steps, clone=False)
