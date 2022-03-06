---
name: Bug report
about: Something that should work, doesn't
title: ''
labels: 'bug'
assignees: ''

---

#### What is the nature of the problem
A clear and concise description of the issue.

----

#### How may it be reproduced
The FULL configuration required to reproduce the issue:
```
base:
  name: myhostname.example.local
  user: myusername
```

Aswell as any
 1. additional steps
 2. required
 3. to reproduce

----

#### What should have happened
A clear and concise description of what you expected to happen.

----

#### What happened instead
A clear and concise description of what did happen instead.

This is where you should include your the error output.

----
#### What is your environment
Paste the output of the following commands:
 * On the controlling machine:
    1. `which fsa && fsa --version`
```
my result here
```

    2. `which ansible && ansible --version`
```
my result here
```

    3. `echo $SHELL`
```
my result here
```

    4. `uname -a`
```
my result here
```

    5. `cat /etc/issue`
```
my result here
```

 * On the target host:
    1. `which python3 && python3 --version`
```
my result here
```

    2. `echo $SHELL`
```
my result here
```

    3. `uname -a`
```
my result here
```

    4. `cat /etc/issue`
```
my result here
```

----

#### Any additional context about the issue
 * How big is the impact?
 * Anything specific you wish to add?
