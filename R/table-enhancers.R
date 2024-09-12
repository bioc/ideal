# table-enhancers.R



createLinkGO <- function(val) {
  .Deprecated(old = "createLinkGO", new = "mosdef::create_link_GO")
  
  mosdef::create_link_GO(val = val)
}

createLinkENS <- function(val, species = "Mus_musculus") {
  .Deprecated(old = "createLinkENS", new = "mosdef::create_link_ENSEMBL")
  
  mosdef::create_link_ENSEMBL(val = val, species = species)
}

createLinkGeneSymbol <- function(val) {
  .Deprecated(old = "createLinkGeneSymbol", new = "mosdef::create_link_NCBI")
  
  mosdef::create_link_NCBI(val = val)
}


geneinfo <- function(gene_id) {
  # the gene id has to be entrez_id

  ## TODO: will need to finish implementation
  entrezinfo <- rentrez::entrez_summary("gene", gene_id)

  return(entrezinfo)
}
