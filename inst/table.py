
import csv
from os import listdir
from os.path import isfile, join, basename

import numpy as np
import matplotlib.pyplot as plt

def iso_path(path = "inst/extdata/db"):
    filepath = join(path, "ISO.csv")
    assert isfile(filepath)
    return filepath
def csv_paths(path = "inst/extdata/db"):
    countries = [f for f in listdir(path) if isfile(join(path,f)) and f[-4:] == ".csv" and f != "ISO.csv"]
    return map(lambda x: join(path,x), countries)
    
def main():
    with open(iso_path()) as fp:
        iso = list(csv.DictReader(fp))
        iso = {c['iso_alpha_3']: dict(c) for c in iso}

    # detect countries
    print("Countries detected:")
    missing_countries = []
    for c in csv_paths():
        country_code = basename(c)[:-4] # remove .csv
        try:
            print(f"\t{iso[country_code]['country']}")
        except: # country_code not found
            missing_countries.append(country_code)
    if missing_countries:
        print("Unknown:", ','.join(missing_countries))
    print("")
    
    # coverage of variables
    coverage_by_variables = {}
    for c in csv_paths():
        country_code = basename(c)[:-4] # remove .csv
        with open(c,encoding="UTF-8") as fp:
            reader = csv.DictReader(fp)
            variables = reader.fieldnames
            country = list(reader)
            N = len(country)
        for var in variables:
            variable_covered = sum(map(lambda x: x[var] != '', country))/N
            try:
                coverage_by_variables[var][country_code] = variable_covered
            except:
                coverage_by_variables[var] = {country_code: variable_covered}
    # create heatmap
    all_variables = coverage_by_variables.keys()
    all_countries = list(map(lambda x: basename(x)[:-4],csv_paths()))
    coverage = []
    for v in all_variables:
        variable_coverage = []
        for c in all_countries:
            try:
                variable_coverage.append(coverage_by_variables[v][c])
            except:
                variable_coverage.append(0.0)
        coverage.append(variable_coverage)
    coverage = np.array(coverage)
    fig, ax = plt.subplots()
    im = ax.imshow(coverage)
    ax.set_xticks(np.arange(len(all_countries)))
    ax.set_yticks(np.arange(len(all_variables)))
    ax.set_xticklabels(all_countries)
    ax.set_yticklabels(all_variables)
    plt.setp(ax.get_xticklabels(), rotation=45, ha="right", rotation_mode="anchor")
    
    for i in range(len(all_variables)):
        for j in range(len(all_countries)):
            text = ax.text(j, i, round(coverage[i, j],1),
                           ha="center", va="center", color="w")
    ax.set_title("Coverage of slow-changing variables")
    fig.tight_layout()
    plt.show()
    
    
    
    
    
    
    
    
    
    
if __name__ == "__main__":
    main()
