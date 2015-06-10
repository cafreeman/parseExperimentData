#Parse Experiment Data
An R package for parsing raw experimental data from <insert name of tool here>.

##Installation:
To install directly from GitHub, use the following command:
```R
library(devtools)
install_github("cafreeman/parseExperimentData")
```

###Example usage:
```R
library(parseExperimentData)

rawExceltbl <- load(<path>/rawExceltbl.rda)
rawKeytbl <- load(<path>/rawKeytbl.rda)

test <- parseExperimentData(rawExceltbl, rawKeytbl)
```
