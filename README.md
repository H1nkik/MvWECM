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

INPUT: views \times n x d matrix 

## Usage
The platform is i7-13700 + 24G.

## Parameters

| datasets         | alpha     | beta    | delta |  eta  | preprocessing  | 
| -------------- | -------- | ---------- | --------------------------- | ------| ------|
| `Prok`         | 1    | 1~403         | 2     | 1 |`normalize` |
| `Webkb`        | 1    | 3~340         | 13~15 | 1|`0-1` |
| `IS`           | 1    | 241, 259      | 2~3  | 1 |`normalize` |
| `Caltech07`    | 1    | 277           | 4     | 1 |`0-1` |
| `3sources`     | 1    | 1             | 9~20 | 1 |`0-1`|
| `Reuters-1500` | 1    | xxx           | xxx | 1 |`normalize` |
| `Reuters-18758`| 1.25 | 58            | 2 | 1 |`normalize` |
