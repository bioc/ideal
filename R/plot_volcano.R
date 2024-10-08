#' Volcano plot for log fold changes and log p-values
#'
#' Volcano plot for log fold changes and log p-values in the ggplot2 framework, with
#' additional support to annotate genes if provided.
#'
#' The genes of interest are to be provided as gene symbols if a `symbol`
#' column is provided in `res_obj`, or else b< using  the identifiers specified
#' in the row names
#'
#' @param res_obj A [DESeqResults()] object
#' @param FDR Numeric value, the significance level for thresholding adjusted p-values
#' @param ylim_up Numeric value, Y axis upper limits to restrict the view
#' @param vlines The x coordinate (in absolute value) where to draw vertical lines,
#' optional
#' @param title A title for the plot, optional
#' @param intgenes Vector of genes of interest. Gene symbols if a `symbol`
#' column is provided in `res_obj`, or else the identifiers specified in the
#' row names
#' @param intgenes_color The color to use to mark the genes on the main plot.
#' @param labels_intgenes Logical, whether to add the gene identifiers/names close
#' to the marked plots
#' @param labels_repel Logical, whether to use `geom_text_repel` for placing the
#' labels on the features to mark
#'
#' @return An object created by `ggplot`
#' @export
#'
#' @examples
#' library("airway")
#' data("airway", package = "airway")
#' airway
#' dds_airway <- DESeq2::DESeqDataSetFromMatrix(assay(airway),
#'   colData = colData(airway),
#'   design = ~ cell + dex
#' )
#'
#' # subsetting for quicker run, ignore the next two commands if regularly using the function
#' gene_subset <- c(
#'   "ENSG00000103196", # CRISPLD2
#'   "ENSG00000120129", # DUSP1
#'   "ENSG00000163884", # KLF15
#'   "ENSG00000179094", # PER1
#'   rownames(dds_airway)[rep(c(rep(FALSE, 99), TRUE), length.out = nrow(dds_airway))]
#' ) # 1% of ids
#' dds_airway <- dds_airway[gene_subset, ]
#'
#' dds_airway <- DESeq2::DESeq(dds_airway)
#' res_airway <- DESeq2::results(dds_airway)
#'
#' plot_volcano(res_airway)
plot_volcano <- function(res_obj,
                         FDR = 0.05,
                         ylim_up = NULL,
                         vlines = NULL,
                         title = NULL,
                         intgenes = NULL,
                         intgenes_color = "steelblue",
                         labels_intgenes = TRUE,
                         labels_repel = TRUE) {
  mydf <- as.data.frame(res_obj)
  mydf$id <- rownames(mydf)
  mydf$isDE <- ifelse(is.na(res_obj$padj), FALSE, res_obj$padj < FDR)

  mydf <- mydf[mydf$baseMean > 0, ]

  p <- ggplot(mydf, aes_string(x = "log2FoldChange", y = "-log10(pvalue)")) +
    geom_point(aes_string(color = "isDE"), alpha = 0.4)

  if (!is.null(ylim_up)) {
    p <- p + coord_cartesian(ylim = c(0, ylim_up))
  } else {
    p <- p + coord_cartesian(ylim = c(0, 20))
  }

  if (!is.null(title)) {
    p <- p + ggtitle(title)
  }

  p <- p + theme_bw() +
    scale_colour_manual(
      name = paste0("FDR = ", FDR),
      values = c("black", "red"),
      labels = c("nonDE", "DE")
    )

  p <- p + geom_vline(aes(xintercept = 1), col = "lightblue", alpha = 0.6, size = 1.5) +
    geom_vline(aes(xintercept = -1), col = "lightblue", alpha = 0.6, size = 1.5)

  if (!is.null(intgenes)) {
    if ("symbol" %in% colnames(mydf)) {
      # use the gene names
      df_intgenes <- mydf[mydf$symbol %in% intgenes, ]
      df_intgenes$myids <- df_intgenes$symbol
    } else {
      # use whatever is there as id
      df_intgenes <- mydf[rownames(mydf) %in% intgenes, ]
      df_intgenes$myids <- rownames(df_intgenes)
    }

    # df_intgenes <- mydf[mydf$symbol %in% intgenes,]

    p <- p + geom_point(data = df_intgenes, aes_string("log2FoldChange", "-log10(pvalue)"), color = intgenes_color, size = 4)

    if (labels_intgenes) {
      
      if (labels_repel) {
        p <- p + geom_text_repel(
          data = df_intgenes, aes_string("log2FoldChange", "-log10(pvalue)", label = "myids"),
          color = intgenes_color, size = 5
        )
      } else {
        p <- p + geom_text(
          data = df_intgenes, aes_string("log2FoldChange", "-log10(pvalue)", label = "myids"),
          color = intgenes_color, size = 5, hjust = 0.25, vjust = -0.75
        )
      }
      
    }
  }

  p
}
