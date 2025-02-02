% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Cal_FS.R
\name{FAS_cal}
\alias{FAS_cal}
\title{A function for smoothed or un-smoothed Fourier Amplitude Spectrum (FAS) calculation}
\usage{
FAS_cal(
  acc,
  dt,
  normalization_factor = 0,
  smooth_flag = FALSE,
  smooth_bandwidth = 20
)
}
\arguments{
\item{acc}{An array of acceleration time series, in g.}

\item{dt}{The time step in second.}

\item{normalization_factor}{The indicator of normalization factor. 0 stands for no normalization;
1 stands for normalized by time step -- integration over time;
2 stands for normalized by 1/sqrt(N) -- unitary normalization;
3 stands for normalzied by 1/N;
4 stands for normalized by time step and 1/sqrt(N)}

\item{smooth_flag}{An indicator specifies whether a Konno and Ohmachi (1998) smooth method is applied}

\item{smooth_bandwidth}{If \code{smooth_flag} is TRUE, then \code{smooth_bandwidth} will be used to determine
the smoothing bandwidth.}
}
\value{
A list is returned with FFT, FAS, the associated frequency of FAS, the associated phase,
and smoothed FAS if \code{smooth_flag} is TURE.
}
\description{
This function computes smoothed or un-smoothed FAS
}
\examples{
FAS_cal(acc = h1$data, dt = h1$dt, smooth_flag = TRUE)
}
\keyword{FAS}
