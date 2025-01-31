# Copyright (c) [2020] [Monica T. Hannani]
# mhannani@ukaachen.de


#---- Differential gene expression analysis across conditions of integrated data

library(Seurat)
library(dplyr)
library(ggplot2)
indir = '~/sciebo/CovidEpiMap/integrated/'
source('sc_source/sc_source.R')


sc = readRDS(file = paste0(indir, 'integrated.RNA.Tcells.annotated.rds'))
DefaultAssay(sc) = 'RNA'


cell.types = levels(Idents(sc))
sc$celltype.condition = paste(Idents(sc), sc$condition)
Idents(sc) = 'celltype.condition'


# Cell type vs cell type across conditions
for (cell.type in cell.types){
	# Healthy vs active mild
	condition = 'active_mild'
	control = 'healthy'

	markers = get_markers(sc, condition = condition, 
		control = control, cell.type = cell.type)

	top_heatmap(sc, markers = markers, cell.type = cell.type, 
		disease = condition, control = control, n = 15)


	# Healthy vs active severe
	condition = 'active_severe'
	control = 'healthy'

	markers = get_markers(sc, condition = condition, 
		control = control, cell.type = cell.type)
	
	top_heatmap(sc, markers = markers, cell.type = cell.type, 
		disease = condition, control = control, n = 15)


	# Mild vs severe active
	condition = 'active_severe'
	control = 'active_mild'

	markers = get_markers(sc, condition = condition, 
		control = control, cell.type = cell.type)
	
	top_heatmap(sc, markers = markers, cell.type = cell.type, 
		disease = condition, control = control, n = 15)


	# Mild vs severe recovered
	condition = 'recovered_severe'
	control = 'recovered_mild'

	markers = get_markers(sc, condition = condition, 
		control = control, cell.type = cell.type)
	
	top_heatmap(sc, markers = markers, cell.type = cell.type, 
		disease = condition, control = control, n = 15)
}


# Global DE between COVID vs NON-COVID
outdir = '~/sciebo/CovidEpiMap/diff_expression/'
Idents(sc) = 'COVID'
condition = 'COVID'
control = 'NON-COVID'

markers = FindMarkers(sc, ident.1 = condition, 
                      ident.2 = control, 
                      min.pct = 0.25, 
                      logfc.threshold = 0)
markers$gene = rownames(markers)

write.table(markers[,c(6, 1:5)], 
           file = paste0(outdir, 'integrated.diff.genes.', condition, '.vs.', control, '.txt'),
           quote = FALSE, 
           sep = '\t', 
           row.names = FALSE)

