#' A function for smoothed or un-smoothed Fourier Amplitude Spectrum (FAS) calculation
#'
#' This function computes smoothed or un-smoothed FAS
#' @param acc An array of acceleration time series, in g.
#' @param dt The time step in second.
#' @param normalization_factor The indicator of normalization factor. 0 stands for no normalization;
#' 1 stands for normalized by time step -- integration over time;
#' 2 stands for normalized by 1/sqrt(N) -- unitary normalization;
#' 3 stands for normalzied by 1/N;
#' 4 stands for normalized by time step and 1/sqrt(N)
#' @param smooth_flag An indicator specifies whether a Konno and Ohmachi (1998) smooth method is applied
#' @param smooth_bandwidth If \code{smooth_flag} is TRUE, then \code{smooth_bandwidth} will be used to determine
#' the smoothing bandwidth.
#' @return A list is returned with FFT, FAS, the associated frequency of FAS, the associated phase,
#' and smoothed FAS if \code{smooth_flag} is TURE.
#' @examples FAS_cal(acc = h1$data, dt = h1$dt, smooth_flag = TRUE)
#' @keywords FAS
#' @importFrom stats fft
#' @export
FAS_cal <- function(acc, dt, normalization_factor = 0, smooth_flag = FALSE, smooth_bandwidth = 20){
  nfft <- length(acc)
  nNyq <- ceiling(nfft / 2)
  df <- 1 / (nfft * dt)
  fft_ts <- stats::fft(acc)
  if (normalization_factor == 1) {
    fft_ts <- fft_ts * dt
  } else if (normalization_factor == 2) {
    fft_ts <- fft_ts * (1 / sqrt(nfft))
  } else if (normalization_factor == 3) {
    fft_ts <- fft_ts * (1 / nfft)
  } else if (normalization_factor == 4) {
    fft_ts <- fft_ts * dt * (1 / sqrt(nfft))
  }
  amp <- abs(fft_ts)[1:nNyq]
  phase <- Arg(fft_ts)[1:nNyq]
  freq <- ((1:nNyq) - 1) * df
  output <- list()
  output$FFT <- fft_ts
  output$FAS <- amp
  output$Freq <- freq
  output$Phase <- phase

  if (smooth_flag) {
    output$smoothed_FAS <- KO_smooth(freq = output$Freq, amp = output$FAS, b = smooth_bandwidth)
  }

  return(output)
}



#' A function for smoothed or un-smoothed Effective Fourier Amplitude Spectrum (EAS) calculation
#'
#' This function computes smoothed or un-smoothed EAS
#' @param data1 The first horizontal component of acceleration ground motion, in g
#' @param data2 The second horizontal component of acceleration ground motion, in g
#' @param dt Time step of two time series, in second. We assume that the two time series have the same time step.
#' @param normalization_factor The indicator of normalization factor. 0 stands for no normalization;
#' 1 stands for normalized by time step -- integration over time;
#' 2 stands for normalized by 1/sqrt(N) -- unitary normalization;
#' 3 stands for normalzied by 1/N;
#' 4 stands for normalized by time step and 1/sqrt(N)
#' @param smooth_flag An indicator specifies whether a Konno and Ohmachi (1998) smooth method is applied
#' @param smooth_bandwidth If \code{smooth_flag} is TRUE, then \code{smooth_bandwidth} will be used to determine
#' the smoothing bandwidth.
#' @return A list is returned with EAS, the associated frequency of FAS, and smoothed EAS if \code{smooth_flag} is TURE.
#' @examples EAS_cal(data1 = h1$data, data2 = h2$data, dt = h1$dt)
#' @keywords EAS
#' @importFrom stats fft
#' @export
EAS_cal <- function(data1, data2, dt, normalization_factor = 0, smooth_flag = TRUE, smooth_bandwidth = 20){

  output1 <- FAS_cal(acc = data1, dt = dt, normalization_factor = normalization_factor)
  output2 <- FAS_cal(acc = data2, dt = dt, normalization_factor = normalization_factor)

  output <- list()
  output$Freq <- output1$Freq
  output$EAS <- sqrt((output1$FAS^2 + output2$FAS^2) / 2)

  if (smooth_flag) {
    output$smoothed_EAS <- KO_smooth(freq = output$Freq, amp = output$EAS, b = smooth_bandwidth)
  }

  return(output)
}


