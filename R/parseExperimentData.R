#' @title parseExperimentData
#' @description Transform experiment data into long form with relevant keys
#' @rdname parseExperimentData
#'
#' @param data A data frame containing raw experiment data in wide form
#' @param lookupTable A data frame containing per-well categorical fields (e.g. medium, clone, etc.)
#' @param numMeasurements (OPTIONAL) The number of measurements performed on the set of wells
#'  If no argument is specified, numMeasurements defaults to 3.
#' @param numWells (OPTIONAL) The number of wells used in the experiment. If no argument is specified,
#'  numWells defaults to 96.
#'
#' @details parseExperimentData will take raw experiment data in wide form and transform it into
#'  long form with the following keys:
#'  \itemize{
#'    \item{well}
#'    \item{measurementType}
#'    \item{cycle}
#'    \item{time}
#'  }
#'  The long-form experiment data is then joined to a lookup table containing qualitative information
#'  about each well. The qualitative data is replicated per-well for each instance of the well in
#'  the long-form data.
#'
#'  parseExperimentData takes optional arguments specifying the number of measurements and the
#'  number of wells. This information is used to dynamically ascertain the measurement type for each
#'  iteration in the data and is appended as a new column. If no values are specified, it assumes
#'  3 measurements and 96 wells.
#'
#' @export
parseExperimentData <- function(data, lookupTable, numMeasurements = 3, numWells = 96) {
  rowsPerMeasure <- numWells + 4

  data %T>%
  {
    colnames(.) <- c("well", paste(data[2,][2:ncol(data)], data[3,][2:ncol(data)], sep ="|"))
  } %>%
  {
    measurementLocations <- seq_along(rownames(data))[seq(1, (rowsPerMeasure * numMeasurements), rowsPerMeasure)]
    mutate(., measurementType = rep(data[[1]][measurementLocations], each = rowsPerMeasure)) %>%
    {
      metadataRows <- unlist(lapply(measurementLocations,
                                    function(i) {
                                      seq(i, i+3)
                                    }))
      slice(., -c(metadataRows))
    }
  } %>%
    gather(key, value, -well, -measurementType) %>%
    separate(key, into = c("cycle", "time"), sep ="\\|") %>%
    inner_join(lookupTable, by = "well") %>%
    arrange(well)
}
