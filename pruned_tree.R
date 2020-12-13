require(phangorn)
require(tools)
setwd("path/")

pruneTreeFromAln = function (treefile, alnfile, type = "AA", format = "fasta", writetree=TRUE) {
  #prune the tree to have only the species in the alignment
  #read in the alignment
  alnPhyDat = read.phyDat(alnfile, type = type, format = format)
  #read in the treefile
  genetree = read.tree(treefile)
  #eliminate species in the alignment but not the tree and vice versa
  inboth = intersect(names(alnPhyDat),genetree$tip.label)
  todrop = genetree$tip.label[genetree$tip.label %in% inboth == FALSE]
  if (length(todrop) > 0) {
    genetree = drop.tip(genetree, todrop)
  }
  #unroot the tree
  genetree = unroot(genetree)
  if (writetree) {
    #write the new tree with a revised filename
    fe = file_ext(treefile)
    fpse = file_path_sans_ext(treefile)
    write.tree(genetree, file=paste(fpse,".pruned.",fe,sep=""))
  }
  return(genetree)
}


pruneTreeFromAln("{gene}.fas","{tree}.txt")
