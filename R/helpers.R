# helpers.R





footer <- function() {
  tags$div(
    class = "panel-footer",
    style = "text-align:center",
    tags$div(
      class = "foot-inner",
      list(
        # hr(),
        "ideal is a project developed by Federico Marini in the Bioinformatics division of the ",
        tags$a(href = "http://www.unimedizin-mainz.de/imbei", "IMBEI"),
        "- Institute for Medical Biostatistics, Epidemiology and Informatics", br(),
        "License: ", tags$a(href = "https://opensource.org/licenses/MIT", "MIT"), br(),

        "Development of the ideal package is on ",
        tags$a(href = "https://github.com/federicomarini/ideal", "GitHub")
      )
    )
  )
}







############################# helper funcs #################################

#' Make an educated guess on the separator character
#'
#' This function tries to guess which separator was used in a text delimited file
#'
#' @param file The name of the file which the data are to be read from
#' @param sep_list A vector containing the candidates for being identified as
#' separators. Defaults to `c(",", "\t", ";"," ")`
#'
#' @return A character value, corresponding to the guessed separator. One of ","
#' (comma), "\\t" (tab), ";" (semicolon)," " (whitespace)
#' @export
#'
#' @examples
#' sepguesser(system.file("extdata/design_commas.txt", package = "ideal"))
#' sepguesser(system.file("extdata/design_semicolons.txt", package = "ideal"))
#' sepguesser(system.file("extdata/design_spaces.txt", package = "ideal"))
#' mysep <- sepguesser(system.file("extdata/design_tabs.txt", package = "ideal"))
#'
#' # to be used for reading in the same file, without having to specify the sep
sepguesser <- function(file, sep_list = c(",", "\t", ";", " ")) {
  separators_list <- sep_list
  rl <- readLines(file, warn = FALSE)
  rl <- rl[rl != ""] # allow last line to be empty
  sephits_min <- sapply(separators_list, function(x) min(stringr::str_count(rl, x))) # minimal number of separators on all lines
  sep <- separators_list[which.max(sephits_min)]
  sep
}

sepguesser2 <- function(file, sep_list = c(",", "\t", ";", " ")) {
  separators_list <- sep_list
  rl <- readLines(file, warn = FALSE)
  rl <- rl[rl != ""] # allow last line to be empty
  sephits_min <- sapply(separators_list, function(x) min(stringr::str_count(rl, x))) # minimal number of separators on all lines

  counts <- sapply(separators_list, function(x) min(count.fields(textConnection(rl), sep = x)))

  sep <- separators_list[which.max(counts)]
  # sep = separators_list[which.max(sephits_min)]
  sep
}



shake_topGOtableResult <- function(obj,
                                   p_value_column = "p.value_elim") {
  
  if(!all(c("GO.ID", "Term", "Annotated", "Significant", "Expected", "p.value_classic") %in%
          colnames(obj))) {
    stop("The provided object must be of in the format specified by the `mosdef::run_topGO` function")
  }
  
  if(!p_value_column %in% colnames(obj)) {
    stop("You specified a column for the p-value which is not contained in the provided object. \n",
         "Please check the colnames of your object in advance.")
  }
  
  if(!"genes" %in% colnames(obj)) {
    stop("The column `genes` is not present in the provided object and is required for properly running GeneTonic.",
         "\nMaybe you did set `add_gene_to_terms` to FALSE in the call to `mosdef::run_topGO`?")
  }
  
  # Thought: store somewhere the ontology if possible - in an extra column?
  message("Found ", nrow(obj), " gene sets in `topGOtableResult` object.")
  message("Converting for usage in GeneTonic...")
  
  fullresults <- obj
  
  mydf <- data.frame(
    gs_id = fullresults$GO.ID,
    gs_description = fullresults$Term,
    gs_pvalue = fullresults[[p_value_column]],
    gs_genes = fullresults$genes,
    gs_de_count = fullresults$Significant,
    gs_bg_count = fullresults$Annotated,
    Expected = fullresults$Expected,
    stringsAsFactors = FALSE
  )
  
  rownames(mydf) <- mydf$gs_id
  
  return(mydf)
}




# combineTogether <- function(normCounts,resuTable,anns) {
#   combinedCountsAndRes <- inner_join(resuTable,normCounts,by="id")
#   anns2 <- anns[match(combinedCountsAndRes$id, anns[, 1]), ]
#   combinedCountsAndRes$Description <- anns2$description
#   return(combinedCountsAndRes)
# }
#
#
# combine_resucounts <- function(normCounts,resuTable) {
#   combinedCountsAndRes <- inner_join(resuTable,normCounts,by="id")
#   # anns2 <- anns[match(combinedCountsAndRes$id, anns[, 1]), ]
#   # combinedCountsAndRes$Description <- anns2$description
#   return(combinedCountsAndRes)
# }
#

# getGeneInfos <- function(obj, annopkg, idtype) {
#   # obj is a dds object...
#   ids <- rownames(obj)
#
#   mydf <- mapIds(eval(parse(text=annopkg)),keys=ids,column = "GENENAME",keytype = idtype)
#   mydf_2 <- AnnotationDbi::select(eval(parse(text=annopkg)),keys=ids,column = "GENENAME",keytype = idtype)
#
#   return(mydf_2)
# }
#
#
