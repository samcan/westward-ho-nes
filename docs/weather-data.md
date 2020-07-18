# Weather data
Anomaly data is the mean temperature for the month for roughly 1973–2019 compared
to the mean temperature for the 1981–2010 base period. I'm using the anomaly numbers
to give me a range to generate random numbers in.

Mean is the mean temperature for the month during 1981–2010 base period.

Data sourced from [NOAA's Climate at a Glance][ncdc].

## Generating random numbers consistent with the data
I tried to overly complicate this in my head, trying to figure out how I could
approximate a distribution curve using 6502 assembly. But I finally decided to
cut the Gordian knot as follows:

* 75% of values should be within anomaly range around the mean
* 22% of values should be within 2× anomaly range around the mean
* 3% of values should be within 3× anomaly range around the mean

And if some of the values don't make sense, we'll limit as necessary. For
example, rainfall can't be less than 0 inches. And right now we're limiting
temperature to 0°F as a minimum and 125°F as a maximum. Any values outside these
extremes we'd just set as the extreme values. Since we're just using graphical
status icons in general to display this data, it'll be fine. If "very cold" is
anything below 10°F, the player won't know if it's 0°F or -25°F, and the effect
on the player will be the same.

## At what milepost weather should be changed
Weather will change at these mileposts, which are approximate midpoints between
the cities we have historical weather data for:

| Mile  | City                 |
| ----: | :------------------- |
|     0 | Kansas City, MO      |
|   209 | North Platte, NE     |
|   595 | Casper, WY           |
|   842 | Lander, WY           |
| 1,140 | Boise, ID            |
| 1,676 | Portland, OR         |

## Kansas City, MO
| Month | Mean (°F) | + Anomaly (°F) | - Anomaly (°F) |
| ----: | --------: | -------------: | -------------: |
|  1    | 28.8      |  11.6          | -16.0          |
|  2    | 33.5      |  10.2          | -13.6          |
|  3    | 44.2      |  14.2          |  -7.9          |
|  4    | 54.8      |   6.6          |  -8.2          |
|  5    | 64.5      |   8.9          |  -5.2          |
|  6    | 73.5      |   5.1          |  -4.4          |
|  7    | 78.2      |   7.2          |  -4.7          |
|  8    | 77.1      |   6.8          |  -6.4          |
|  9    | 68.1      |   6.7          |  -6.2          |
| 10    | 56.3      |   5.5          |  -5.7          |
| 11    | 43.5      |   8.3          |  -7.9          |
| 12    | 31.4      |   8.3          | -17.9          |

| Month | Mean (in) | + Anomaly (in) | - Anomaly (in) |
| ----: | --------: | -------------: | -------------: |
|  1    | 1.07      |   1.60         |  -1.05         |
|  2    | 1.46      |   1.79         |  -1.41         |
|  3    | 2.37      |   6.72         |  -2.04         |
|  4    | 3.70      |   4.73         |  -3.03         |
|  5    | 5.23      |   7.59         |  -4.23         |
|  6    | 5.22      |   6.63         |  -4.24         |
|  7    | 4.46      |  11.02         |  -4.33         |
|  8    | 3.89      |   6.30         |  -3.38         |
|  9    | 4.61      |   6.73         |  -3.49         |
| 10    | 3.16      |   7.60         |  -2.95         |
| 11    | 2.15      |   2.98         |  -2.15         |
| 12    | 1.53      |   3.89         |  -1.50         |

## North Platte, NE (1948–2019)
| Month | Mean (°F) | + Anomaly (°F) | - Anomaly (°F) |
| ----: | --------: | -------------: | -------------: |
|  1    | 25.7      |  11.7          | -18.1          |
|  2    | 29.7      |  11.6          | -13.5          |
|  3    | 38.7      |  11.6          | -13.9          |
|  4    | 48.3      |   7.1          |  -5.9          |
|  5    | 58.6      |   6.4          |  -5.9          |
|  6    | 68.5      |   7.5          |  -6.4          |
|  7    | 74.9      |   5.9          |  -6.4          |
|  8    | 72.8      |   5.4          |  -6.2          |
|  9    | 62.9      |   6.8          |  -8.1          |
| 10    | 49.7      |   9.4          |  -8.3          |
| 11    | 36.3      |   7.7          | -11.5          |
| 12    | 26.1      |   8.6          | -18.4          |

| Month | Mean (in) | + Anomaly (in) | - Anomaly (in) |
| ----: | --------: | -------------: | -------------: |
|  1    | 0.34      |   1.86         |  -0.35         |
|  2    | 0.50      |   1.49         |  -0.50         |
|  3    | 1.05      |   3.32         |  -1.04         |
|  4    | 2.27      |   3.67         |  -2.19         |
|  5    | 3.28      |   4.74         |  -2.53         |
|  6    | 3.41      |   7.06         |  -3.08         |
|  7    | 3.07      |   3.99         |  -2.93         |
|  8    | 2.29      |   4.02         |  -2.23         |
|  9    | 1.41      |   4.62         |  -1.41         |
| 10    | 1.55      |   3.24         |  -1.49         |
| 11    | 0.64      |   2.25         |  -0.62         |
| 12    | 0.41      |   2.15         |  -0.41         |

## Casper, WY (1948–2019)
| Month | Mean (°F) | + Anomaly (°F) | - Anomaly (°F) |
| ----: | --------: | -------------: | -------------: |
|  1    | 24.6      |   6.7          | -18.7          |
|  2    | 26.5      |   8.2          | -16.2          |
|  3    | 34.8      |   9.3          | -15.6          |
|  4    | 42.4      |   5.7          |  -8.0          |
|  5    | 51.9      |   6.6          |  -7.6          |
|  6    | 62.0      |   9.0          |  -7.5          |
|  7    | 70.2      |   5.0          |  -6.1          |
|  8    | 68.7      |   4.4          |  -5.9          |
|  9    | 57.5      |   7.1          | -11.1          |
| 10    | 45.1      |   7.7          |  -8.5          |
| 11    | 33.0      |  10.8          | -14.3          |
| 12    | 23.7      |   9.7          | -14.3          |

| Month | Mean (in) | + Anomaly (in) | - Anomaly (in) |
| ----: | --------: | -------------: | -------------: |
|  1    | 0.50      |   0.93         |  -0.50         |
|  2    | 0.57      |   0.85         |  -0.44         |
|  3    | 0.83      |   1.61         |  -0.70         |
|  4    | 1.29      |   2.63         |  -1.21         |
|  5    | 2.02      |   4.45         |  -1.71         |
|  6    | 1.61      |   3.09         |  -1.58         |
|  7    | 1.41      |   2.13         |  -1.31         |
|  8    | 0.85      |   1.81         |  -0.83         |
|  9    | 1.08      |   2.32         |  -1.01         |
| 10    | 1.11      |   3.51         |  -1.12         |
| 11    | 0.76      |   1.96         |  -0.72         |
| 12    | 0.61      |   3.10         |  -0.58         |

## Lander, WY (1948–2019)
| Month | Mean (°F) | + Anomaly (°F) | - Anomaly (°F) |
| ----: | --------: | -------------: | -------------: |
|  1    | 21.1      |   9.2          | -21.2          |
|  2    | 24.8      |  10.1          | -15.5          |
|  3    | 35.1      |   8.7          | -12.9          |
|  4    | 43.4      |   6.3          | -10.8          |
|  5    | 52.8      |   6.6          |  -8.5          |
|  6    | 62.4      |   8.5          |  -9.2          |
|  7    | 70.7      |   4.7          |  -7.1          |
|  8    | 69.2      |   3.8          |  -6.2          |
|  9    | 58.2      |   6.6          | -11.8          |
| 10    | 45.2      |   7.0          |  -8.8          |
| 11    | 30.8      |  10.3          | -15.2          |
| 12    | 20.2      |  12.6          | -15.6          |

| Month | Mean (in) | + Anomaly (in) | - Anomaly (in) |
| ----: | --------: | -------------: | -------------: |
|  1    | 0.41      |   1.24         |  -0.42         |
|  2    | 0.58      |   1.60         |  -0.59         |
|  3    | 1.16      |   3.49         |  -1.14         |
|  4    | 1.88      |   4.57         |  -1.68         |
|  5    | 2.20      |   4.59         |  -2.14         |
|  6    | 1.28      |   4.02         |  -1.28         |
|  7    | 0.79      |   1.72         |  -0.79         |
|  8    | 0.61      |   1.77         |  -0.61         |
|  9    | 1.05      |   3.64         |  -1.04         |
| 10    | 1.29      |   3.61         |  -1.29         |
| 11    | 0.86      |   2.51         |  -0.85         |
| 12    | 0.58      |   1.45         |  -0.54         |

## Boise, ID (1940–2019)
| Month | Mean (°F) | + Anomaly (°F) | - Anomaly (°F) |
| ----: | --------: | -------------: | -------------: |
|  1    | 31.2      |  10.6          | -20.1          |
|  2    | 36.4      |   7.9          | -12.3          |
|  3    | 44.3      |   5.6          |  -7.5          |
|  4    | 50.6      |   6.3          |  -6.6          |
|  5    | 58.8      |   6.7          |  -6.1          |
|  6    | 67.3      |   8.6          |  -6.7          |
|  7    | 75.6      |   7.0          |  -9.6          |
|  8    | 74.4      |   4.3          |  -6.3          |
|  9    | 64.7      |   7.3          |  -7.4          |
| 10    | 52.5      |   8.2          |  -6.6          |
| 11    | 39.8      |   7.0          | -11.2          |
| 12    | 30.6      |   8.0          | -17.0          |

| Month | Mean (in) | + Anomaly (in) | - Anomaly (in) |
| ----: | --------: | -------------: | -------------: |
|  1    | 1.24      |   2.64         |  -1.12         |
|  2    | 0.99      |   2.73         |  -0.80         |
|  3    | 1.39      |   2.07         |  -1.22         |
|  4    | 1.23      |   1.81         |  -1.13         |
|  5    | 1.39      |   3.01         |  -1.39         |
|  6    | 0.69      |   2.72         |  -0.67         |
|  7    | 0.33      |   1.29         |  -0.34         |
|  8    | 0.24      |   2.14         |  -0.25         |
|  9    | 0.58      |   2.35         |  -0.59         |
| 10    | 0.74      |   1.85         |  -0.75         |
| 11    | 1.36      |   2.01         |  -1.23         |
| 12    | 1.56      |   2.68         |  -1.46         |

## Portland, OR (1938–2019)
| Month | Mean (°F) | + Anomaly (°F) | - Anomaly (°F) |
| ----: | --------: | -------------: | -------------: |
|  1    | 41.4      |   6.6          | -12.9          |
|  2    | 43.7      |   5.6          |  -7.7          |
|  3    | 48.1      |   4.4          |  -5.8          |
|  4    | 52.3      |   5.5          |  -5.4          |
|  5    | 58.2      |   4.8          |  -4.7          |
|  6    | 63.5      |   6.7          |  -4.9          |
|  7    | 69.1      |   5.0          |  -5.3          |
|  8    | 69.5      |   4.3          |  -5.4          |
|  9    | 64.5      |   3.2          |  -4.2          |
| 10    | 54.8      |   5.2          |  -4.4          |
| 11    | 46.5      |   5.8          |  -9.3          |
| 12    | 40.3      |   6.8          |  -7.3          |

| Month | Mean (in) | + Anomaly (in) | - Anomaly (in) |
| ----: | --------: | -------------: | -------------: |
|  1    | 4.89      |   7.95         |  -4.82         |
|  2    | 3.66      |   7.72         |  -2.94         |
|  3    | 3.68      |   4.22         |  -2.58         |
|  4    | 2.73      |   2.53         |  -2.46         |
|  5    | 2.47      |   3.07         |  -2.37         |
|  6    | 1.70      |   2.58         |  -1.68         |
|  7    | 0.65      |   2.04         |  -0.65         |
|  8    | 0.66      |   3.86         |  -0.67         |
|  9    | 1.47      |   4.15         |  -1.47         |
| 10    | 3.00      |   5.41         |  -2.80         |
| 11    | 5.63      |   6.30         |  -4.85         |
| 12    | 5.48      |   9.76         |  -4.10         |

[ncdc]: https://www.ncdc.noaa.gov/cag/city/mapping