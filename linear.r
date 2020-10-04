library(tidyverse)
library(pracma)

# Interpolate a sine wave at a few points

x = seq(0.0, 5.0, length = 5)
y = sin(x)

# Print the values so can copy them to Stan

options(digits = 10)
print(x)
print(y)

# Plot the interpolated function against the true function

tibble(x_int = seq(min(x), max(x), length = 500)) %>%
  mutate(y_true = sin(x_int),
         y_int = interp1(x, y, x_int)) %>%
  gather(which, value, y_true, y_int) %>%
  ggplot() +
  geom_line(aes(x_int, value, group = which, color = which))

# Here are some points at which we can test our function

x_test = c(1.0, 1.7, 2.1, 4.0)

# Print values at these points (to test Stan implementation)

interp1(x, y, x_test)

fd_deriv = function(x_test) {
  dx = 1e-8
  (interp1(x, y, x_test + dx) - interp1(x, y, x_test - dx)) / (2 * dx)
}

# Print gradients at these points (to test Stan implementation)
# These won't be defined everywhere for linear interpolation

fd_deriv(x_test)
