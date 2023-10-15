import yaml, random

def yaml_pretty(d, indent=8):
    dump = yaml.dump(d)
    res  = map(lambda line: " " * indent + line, dump.strip().split("\n"))
    return "\n".join(list(res))

# generates a unique ip address for each platform and commitid
def network_addr(plat_comid):
    seed = sum([ord(i) for i in plat_comid])
    random.seed(seed)
    d2 = random.randint(12, 31)
    random.seed(seed)
    d3 = random.randint(0, 255)
    return f"172.{d2}.{d3}.0"
