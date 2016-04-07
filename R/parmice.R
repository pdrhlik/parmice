#' Parallel Multivariate Imputation by Chained (PMICE)
#'
#' @description Invokes mice function in parallel using a specified number of cores.
#' @param ncores Number of cores to be used.
#' @return List of imputed datasets.
#' @seealso \code{\link[mice]{mice}}
#' @examples
#' imp <-parmice(nhanes, ncores = 4)
#' plot(imp)
parmice <- function(data, ncores = detectCores() - 1, m = 5,
				   method = vector("character", length = ncol(data)),
				   predictorMatrix = (1 - diag(1, ncol(data))),
				   visitSequence = (1:ncol(data))[apply(is.na(data), 2, any)],
				   form = vector("character", length = ncol(data)),
				   post = vector("character", length = ncol(data)),
				   defaultMethod = c("pmm", "logreg", "polyreg", "polr"),
				   maxit = 5, diagnostics = TRUE,
				   printFlag = TRUE, seed = NA, imputationMethod = NULL,
				   defaultImputationMethod = NULL, data.init = NULL, ...) {
	imputations <- mclapply(1:ncores, FUN = function(no) {
		mice(data, m = ceiling(m / ncores), method = method, predictorMatrix = predictorMatrix,
			 visitSequence = visitSequence, form = form, post = post,
			 defaultMethod = defaultMethod, maxit = maxit, diagnostics = diagnostics,
			 printFlag = printFlag, seed = seed + no - 1, imputationMethod = imputationMethod,
			 defaultImputationMethod = defaultImputationMethod, data.init = data.init, ...)
	}, mc.cores = ncores)
	return(.mergeImputations(imputations))
}

#' Merges parallely computed imputations
.mergeImputations <- function(imps) {
	merged <- imps[[1]]
	if (length(imps) == 1) {
		return(merged)
	}

	for (i in 2:length(imps)) {
		merged <- ibind(merged, imps[[i]])
	}
	return(merged)
}
