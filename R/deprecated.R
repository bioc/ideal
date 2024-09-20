#' Deprecated functions in ideal
#'
#' Functions that are on their way to the function afterlife.
#' Their successors are also listed.
#' 
#' The successors of these functions are likely coming after the rework that
#' led to the creation of the `mosdef` package. See more into its 
#' documentation for more details.
#' 
#' @param ... Ignored arguments.
#' 
#' @return All functions throw a warning, with a deprecation message pointing 
#' towards its descendent (if available).
#' 
#' @name deprecated
#' 
#' @section Transitioning to the mosdef framework:
#' 
#' - [goseqTable()] is now being replaced by the more flexible 
#' [mosdef::run_goseq()] function (which is even faster)
#' - [ggplotCounts()] is now being replaced by the more flexible, better 
#' designed, and actually even more good looking [mosdef::gene_plot()] 
#' function, with better default behavior and all.
#' - [deseqresult2tbl()] and [deseqresult2DEgenes()] are now replaced by the 
#' more flexible [mosdef::deresult_to_df()]
#' - The internally defined functions `createLinkENS()`, `createLinkGeneSymbol()`, 
#' and `createLinkGO()` are now replaced by the equivalent functions in `mosdef`: 
#' [mosdef::create_link_ENSEMBL()], [mosdef::create_link_NCBI()] and 
#' [mosdef::create_link_GO()]. Notably, the `mosdef` package expanded on the 
#' concept of automatically generated buttons, taking this to the extreme of 
#' efficiency with the [mosdef::buttonifier()] function
#' 
#' @author Federico Marini
#' 
#' @examples
#' # try(goseqtable())
#' 
NULL


## #' @export
## #' @rdname defunct
## trendVar <- function(...) {
##   .Defunct("fitTrendVar")
## }
