configfile: "params.yml"
from pathlib import Path

DIROUT = Path(config["DIROUT"])
DIROUT.mkdir(exist_ok=True, parents=True)

DIRCSV=Path(config["DIRCSV"])
NAMES=[p.stem for p in DIRCSV.rglob("*csv")]

print(NAMES)

rule all:   
    input:
        expand( DIROUT.joinpath("sites_haplotypes-{name}.txt"), name=NAMES),
        # expand( DIROUT.joinpath("panel-{name}.txt"), name=NAMES)
        # expand( DIROUT.joinpath("blocks-{name}.txt"), name=NAMES)

rule install_wild_pbwt:
    params: 
        github = "https://github.com/illoxian/Wild-pBWT.git"
    output:
        "Wild-pBWT/bin/wild-pbwt"
    # log:
    #     pjoin(PATH_OUTPUT, "logs", "rule-install_wild_pbwt.err.log"),
    conda:
        "envs/wild-pbwt.yml"
    shell:
        #TODO: if else to check if binary file already exists and is working (skip installation)
        """
        if ! [ -f "Wild-pBWT/bin/wild-pbwt"]; then
            rm -rf Wild-pBWT/
            git clone {params.github} && cd Wild-pBWT
            make wild-pbwt
        else
            echo "wild-pbwt already installed"
        fi
        """

rule create_panel:
    input:
        path_csv=DIRCSV.joinpath("{name}.csv")
    output:
        path_panel=DIROUT.joinpath("panel-{name}.txt")
    shell:
        "python csv2panel.py {input.path_csv} {output.path_panel}"

rule compute_max_blocks:
    input:
        path_wild_pbwt="Wild-pBWT/bin/wild-pbwt",
        path_panel=DIROUT.joinpath("panel-{name}.txt")
    output: 
        path_blocks=DIROUT.joinpath("blocks-{name}.txt")
    params:
        path_pbwt=config["PATH_WILD_PBWT"]
    shell:
        "{params.path_pbwt} -a 2 -f {input.path_panel} -b 2 -o y > {output.path_blocks}"

rule compute_sets:
    input:
        path_blocks=DIROUT.joinpath("blocks-{name}.txt"),
        path_panel=DIROUT.joinpath("panel-{name}.txt")
    output:
        path_sites_hap=DIROUT.joinpath("sites_haplotypes-{name}.txt")
    shell:
        "python blocks2sets.py {output.path_sites_hap} {input.path_panel} {input.path_blocks}"