#' Analysis of network robustness
#'
#' This function performs a \dQuote{targeted attack} of a graph or a
#' \dQuote{random failure} analysis, calculating the size of the largest
#' component after edge or vertex removal.
#'
#' In a targeted attack, it will sort the vertices by either degree or
#' betweenness centrality (or sort edges by betweenness), and successively
#' remove the top vertices/edges. Then it calculates the size of the largest
#' component.
#'
#' In a random failure analysis, vertices/edges are removed in a random order.
#'
#' @param g An \code{igraph} graph object
#' @param type Character string; either \code{'vertex'} or \code{'edge'}
#'   removals. Default: \code{vertex}
#' @param measure Character string; sort by either \code{'btwn.cent'} or
#'   \code{'degree'}, or choose \code{'random'}. Default: \code{'btwn.cent'}
#' @param N Integer; the number of iterations if \code{'random'} is chosen.
#'   Default: \code{1e3}
#' @export
#' @importFrom foreach getDoParRegistered
#' @importFrom doParallel registerDoParallel
#'
#' @return Data table with elements:
#'   \item{type}{Character string describing the type of analysis performed}
#'   \item{measure}{The input argument \code{measure}}
#'   \item{comp.size}{The size of the largest component after edge/vertex
#'     removal}
#'   \item{comp.pct}{Numeric vector of the ratio of maximal component size after
#'     each removal to the observed graph's maximal component size}
#'   \item{removed.pct}{Numeric vector of the ratio of vertices/edges removed}
#'   \item{Group}{Character string indicating the subject group, if applicable}
#'
#' @author Christopher G. Watson, \email{cgwatson@@bu.edu}
#' @references Albert, R. and Jeong, H. and Barabasi, A. (2000) Error and attack
#'   tolerance of complex networks. \emph{Nature}, \bold{406}, 378--381.
#'   \doi{10.1038/35019019}

robustness_random <- function(g, type=c('vertex', 'edge'),
                       measure=c('btwn.cent', 'degree', 'random'), N=1e3) {
  i <- NULL
  stopifnot(is_igraph(g))
  type <- match.arg(type)
  measure <- match.arg(measure)
  orig_max <- max(components(g)$csize)
  n <- switch(type, vertex=vcount(g), edge=ecount(g))
  removed.pct <- seq.int(0, 1, length.out=n+1L)
  if (measure == 'random') {
    otype <- paste('Random', type, 'removal')
    rand <- matrix(rep.int(seq_len(n), N), nrow=n, ncol=N)
    index <- apply(rand, 2L, sample)
  } else {
    otype <- paste('Targeted', type, 'attack')
    max.comp.removed <- rep.int(orig_max, n)
  }
  if (!getDoParRegistered()) {
    cl <- makeCluster(getOption('bg.ncpus'))
    registerDoParallel(cl)
  }
  if (type == 'vertex') {
      if (measure == 'random') {
        max.comp <- foreach(i=seq_len(N), .combine='cbind') %dopar% {
          ord <- igraph::V(g)$name[index[, i]]
          tmp <- rep.int(orig_max, n)
          g.new <- g # added line
          for (j in seq_len(n - 1L)) {
            g.new <- igraph::delete_vertices(g.new, ord[j]) #updated line
            tmp[j + 1L] <- max(igraph::components(g.new)$csize) # updated line
          }
          tmp
        }
        max.comp.removed <- rowMeans(max.comp)

    } else {
      val <- if (measure == 'btwn.cent') centr_betw(g)$res else check_degree(g)
      ord <- V(g)$name[order(val, decreasing=TRUE)]
      for (j in seq_len(n - 1L)) {
        g <- delete_vertices(g, ord[j])
        max.comp.removed[j + 1L] <- max(components(g)$csize)
      }
    }

  } else {
    if (measure == 'degree') {
      stop('For edge attacks, must choose "btwn.cent" or "random"!')
    } else if (measure == 'random') {
      max.comp <- foreach(i=seq_len(N), .combine='cbind') %dopar% {
        el <- as_edgelist(g, names=FALSE)[index[, i], ]
        tmp <- rep.int(orig_max, n)
        for (j in seq_len(n - 1L)) {
          g.rand <- graph_from_edgelist(el[-seq_len(j), , drop=FALSE], directed=FALSE)
          tmp[j + 1L] <- max(components(g.rand)$csize)
        }
        tmp
      }
      max.comp.removed <- rowMeans(max.comp)

    } else {
      ord <- order(E(g)$btwn, decreasing=TRUE)
      el <- as_edgelist(g, names=FALSE)[ord, ]
      for (j in seq_len(n - 1L)) {
        g <- graph_from_edgelist(el[-seq_len(j), , drop=FALSE], directed=FALSE)
        max.comp.removed[j + 1L] <- max(components(g)$csize)
      }
    }

  }
  max.comp.removed <- c(max.comp.removed, 0)
  comp.pct <- max.comp.removed / orig_max
  out <- data.table(type=otype, measure=measure, comp.size=max.comp.removed,
                    comp.pct=comp.pct, removed.pct=removed.pct)
  if ('name' %in% graph_attr_names(g)) out[, eval(getOption('bg.group')) := g$name]
  return(out)
}
