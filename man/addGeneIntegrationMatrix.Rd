% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RNAIntegration.R
\name{addGeneIntegrationMatrix}
\alias{addGeneIntegrationMatrix}
\title{Add a GeneIntegrationMatrix to ArrowFiles or an ArchRProject}
\usage{
addGeneIntegrationMatrix(
  ArchRProj = NULL,
  useMatrix = "GeneScoreMatrix",
  matrixName = "GeneIntegrationMatrix",
  reducedDims = "IterativeLSI",
  seRNA = NULL,
  groupATAC = NULL,
  groupRNA = NULL,
  groupList = NULL,
  sampleCellsATAC = 10000,
  sampleCellsRNA = 10000,
  embeddingATAC = NULL,
  embeddingRNA = NULL,
  dimsToUse = 1:30,
  scaleDims = NULL,
  corCutOff = 0.75,
  plotUMAP = TRUE,
  UMAPParams = list(n_neighbors = 40, min_dist = 0.4, metric = "cosine", verbose = FALSE),
  nGenes = 2000,
  useImputation = TRUE,
  reduction = "cca",
  addToArrow = TRUE,
  scaleTo = 10000,
  genesUse = NULL,
  nameCell = "predictedCell",
  nameGroup = "predictedGroup",
  nameScore = "predictedScore",
  transferParams = list(),
  threads = getArchRThreads(),
  verbose = TRUE,
  force = FALSE,
  logFile = createLogFile("addGeneIntegrationMatrix"),
  ...
)
}
\arguments{
\item{ArchRProj}{An \code{ArchRProject} object.}

\item{useMatrix}{The name of a matrix in the \code{ArchRProject} containing gene scores to be used for RNA integration.}

\item{matrixName}{The name to use for the output matrix containing scRNA-seq integration to be stored in the \code{ArchRProject}.}

\item{reducedDims}{The name of the \code{reducedDims} object (i.e. "IterativeLSI") to retrieve from the designated \code{ArchRProject}.
This \code{reducedDims} will be used in weighting the transfer of data to scRNA to scATAC. See \code{Seurat::TransferData} for more info.}

\item{seRNA}{A \code{SeuratObject} or a scRNA-seq \code{SummarizedExperiment} (cell x gene) to be integrated with the scATAC-seq data.}

\item{groupATAC}{A column name in \code{cellColData} of the \code{ArchRProj} that will be used to determine the subgroupings specified in \code{groupList}.
This is used to constrain the integration to occur across biologically relevant groups.}

\item{groupRNA}{A column name in either \code{colData} (if \code{SummarizedExperiment}) or \code{metadata} (if \code{SeuratObject}) of \code{seRNA} that
will be used to determine the subgroupings specified in \code{groupList}. This is used to constrain the integration to occur across biologically relevant groups.
Additionally this groupRNA is used for the \code{nameGroup} output of this function.}

\item{groupList}{A list of cell groupings for both ATAC-seq and RNA-seq cells to be used for RNA-ATAC integration.
This is used to constrain the integration to occur across biologically relevant groups. The format of this should be a list of groups
with subgroups of ATAC and RNA specifying cells to integrate from both platforms.
For example \code{groupList} <- list(groupA = list(ATAC = cellsATAC_A, RNA = cellsRNA_A), groupB = list(ATAC = cellsATAC_B, RNA = cellsRNA_B))}

\item{sampleCellsATAC}{An integer describing the number of scATAC-seq cells to be used for integration.
This number will be evenly sampled across the total number of cells in the ArchRProject.}

\item{sampleCellsRNA}{An integer describing the number of scRNA-seq cells to be used for integration.}

\item{embeddingATAC}{A \code{data.frame} of cell embeddings such as a UMAP for scATAC-seq cells to be used for density sampling. The \code{data.frame} object
should have a row for each single cell described in \code{row.names} and 2 columns, one for each dimension of the embedding.}

\item{embeddingRNA}{A \code{data.frame} of cell embeddings such as a UMAP for scRNA-seq cells to be used for density sampling. The \code{data.frame} object
should have a row for each single cell described in \code{row.names} and 2 columns, one for each dimension of the embedding.}

\item{dimsToUse}{A vector containing the dimensions from the \code{reducedDims} object to use in clustering.}

\item{scaleDims}{A boolean value that indicates whether to z-score the reduced dimensions for each cell. This is useful for minimizing
the contribution of strong biases (dominating early PCs) and lowly abundant populations. However, this may lead to stronger sample-specific
biases since it is over-weighting latent PCs. If set to \code{NULL} this will scale the dimensions based on the value of \code{scaleDims} when the
\code{reducedDims} were originally created during dimensionality reduction. This idea was introduced by Timothy Stuart.}

\item{corCutOff}{A numeric cutoff for the correlation of each dimension to the sequencing depth. If the dimension has a
correlation to sequencing depth that is greater than the \code{corCutOff}, it will be excluded from analysis.}

\item{plotUMAP}{A boolean determining whether to plot a UMAP for each integration block.}

\item{UMAPParams}{The list of parameters to pass to the UMAP function if "plotUMAP = TRUE". See the function \code{umap} in the uwot package.}

\item{nGenes}{The number of variable genes determined by \code{Seurat::FindVariableGenes()} to use for integration.}

\item{useImputation}{A boolean value indicating whether to use imputation for creating the Gene Score Matrix prior to integration.}

\item{reduction}{The Seurat reduction method to use for integrating modalities. See \code{Seurat::FindTransferAnchors()} for possible reduction methods.}

\item{addToArrow}{A boolean value indicating whether to add the log2-normalized transcript counts from the integrated matched RNA to the Arrow files.}

\item{scaleTo}{Each column in the integrated RNA matrix will be normalized to a column sum designated by \code{scaleTo} prior to adding to Arrow files.}

\item{genesUse}{If desired a character vector of gene names to use for integration instead of determined ones from Seurat::variableGenes.}

\item{nameCell}{A column name to add to \code{cellColData} for the predicted scRNA-seq cell in the specified \code{ArchRProject}. This is useful for identifying which cell was closest to the scATAC-seq cell.}

\item{nameGroup}{A column name to add to \code{cellColData} for the predicted scRNA-seq group in the specified \code{ArchRProject}. See \code{groupRNA} for more details.}

\item{nameScore}{A column name to add to \code{cellColData} for the predicted scRNA-seq score in the specified \code{ArchRProject}. These scores represent
the assignment accuracy of the group in the RNA cells. Lower scores represent ambiguous predictions and higher scores represent precise predictions.}

\item{transferParams}{Additional params to be passed to \code{Seurat::TransferData}.}

\item{threads}{The number of threads to be used for parallel computing.}

\item{verbose}{A boolean value that determines whether standard output includes verbose sections.}

\item{force}{A boolean value indicating whether to force the matrix indicated by \code{matrixName} to be overwritten if it already exists in the given \code{input}.}

\item{logFile}{The path to a file to be used for logging ArchR output.}

\item{...}{Additional params to be added to \code{Seurat::FindTransferAnchors}}
}
\description{
This function, will integrate multiple subsets of scATAC cells with a scRNA experiment, compute matched scRNA profiles and
then store this in each samples ArrowFile.
}
\examples{

#Get Test Project
proj <- getTestProject()

#Get RNA Matrix
sePBMC <- readRDS(
  file.path(system.file("testdata", package = "ArchR"), "seRNA_PBMC.rds")
)

#Gene Integration Matrix
proj <- addGeneIntegrationMatrix(
    ArchRProj = proj, 
    useMatrix = "GeneScoreMatrix",
    matrixName = "GeneIntegrationMatrix",
    reducedDims = "IterativeLSI",
    seRNA = sePBMC,
    addToArrow = FALSE,
    groupRNA = "CellType",
    nameCell = "predictedCell_Un2",
    nameGroup = "predictedGroup_Un2",
    nameScore = "predictedScore_Un2",
    dimsToUse = 1:10,
    nGenes = 250,
    force = TRUE
)

}
