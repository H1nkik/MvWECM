# MvWECM: Multi-view Weighted Evidential C-Means clustering
![Static Badge](https://img.shields.io/badge/Multi%20view%20Clustering-green)
![Static Badge](https://img.shields.io/badge/R-blue)
![Static Badge](https://img.shields.io/badge/Pattern%20Recognition-orange)

## Preparation
**Dependency**
R == 4.4.1

(Rstudio will prompt you to install the missing packages.)

* aricode 

* evclust 

* R.utils

* R.matlab  (optional)

**Data**
INPUT: views x n x d matrix 

## Usage
The platform is i7-13700 + 24G.

## Parameters

| datasets         | alpha     | beta    | delta |  eta  | preprocessing  | 
| -------------- | -------- | ---------- | --------------------------- | ------| ------|
| `Prok`         | `int`    | 10         | 参数1的描述，描述参数的作用和用途 | xxx |`normalize` |
| `Webkb`        | `string` | `"hello"`  | 参数2的描述，这里放置更详细的信息 | xxx|`0-1` |
| `IS`           | `bool`   | `false`    | 参数3的描述，是否启用某个功能 | xxx |`normalize` |
| `Caltech07`    | `float`  | 1.0        | 参数4的描述，用于指定精度等 | xxx |`0-1` |
| `3sources`     | `float`  | 1.0        | 参数4的描述，用于指定精度等 | xxx |`0-1`|
| `Reuters-1500` | `float`  | 1.0        | 参数4的描述，用于指定精度等 | xxx |`normalize` |
| `Reuters-18758`|   1.25   | 58         | 2 | 1 |`normalize` |
