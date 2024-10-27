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
| `Prok`         | 1    | 10         | 参数1的描述，描述参数的作用和用途 | 1 |`normalize` |
| `Webkb`        | 1 | `"hello"`  | 参数2的描述，这里放置更详细的信息 | 1|`0-1` |
| `IS`           | 1   | `false`    | 参数3的描述，是否启用某个功能 | 1 |`normalize` |
| `Caltech07`    | 1  | 1.0        | 参数4的描述，用于指定精度等 | 1 |`0-1` |
| `3sources`     | 1  | 1.0        | 参数4的描述，用于指定精度等 | 1 |`0-1`|
| `Reuters-1500` | 1  | 1.0        | 参数4的描述，用于指定精度等 | 1 |`normalize` |
| `Reuters-18758`|   1.25   | 58         | 2 | 1 |`normalize` |
