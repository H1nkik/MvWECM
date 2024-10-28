# MvWECM: Multi-view Weighted Evidential C-Means clustering
![Static Badge](https://img.shields.io/badge/Multi%20view%20Clustering-green)
![Static Badge](https://img.shields.io/badge/Code-R-blue)
![Static Badge](https://img.shields.io/badge/Pattern%20Recognition-orange)

## Preparation
**Dependency**

R == 4.4.1

(Rstudio will prompt you to install the missing packages.)

* aricode 

* R.utils

* R.matlab

* evclust (optional)

**Data**

INPUT: views x n x d list

Datasets can be found at [Link1](https://github.com/ChuanbinZhang/Multi-view-datasets), [Link2](https://github.com/ZhangqiJiang07/Multi-view_Multi-class_Datasets) and [Link3](https://gitee.com/zhangfk/multi-view-dataset).

## Usage

Just `main.R`. (Change your path and inputting datasets)


## Parameters
Our platform is i7-13700 + 24G (Mac & Win).
We recommend you set `type = "pairs" ` on larger datasets for faster computation.
| datasets         | alpha     | beta    | delta |  eta  | preprocessing  | 
| -------------- | -------- | ---------- | --------------------------- | ------| ------|
| `Prok`         | 1    | 1~403         | 2      | 1 |`normalize` |
| `Webkb`        | 1    | 3~340         | 13~15  | 1 |`0-1`       |
| `IS`           | 1    | 241, 259      | 2~3    | 1 |`normalize` |
| `Caltech07`    | 1    | 277           | 4      | 1 |`0-1`       |
| `3sources`     | 1    | 1             | 9~20   | 1 |`0-1`       |
| `Reuters-1500` | 1    | 29            | 3      | 1 |`0-1`       |
| `Reuters-18758`| 1.25 | 58            | 2      | 1 |`normalize` |

Remark: If methods do not output `credal partition`, please change `if_credal_id`.

## Citation

If you find MvWECM useful in your research, please consider citing:

**BibTeX**
```bibtex
@article{zhou2025,
  title        = {MvWECM: Multi-View Weighted Evidential C-Means Clustering},
  author       = {Zhou, Kuang and Zhu, Yuchen and Guo, Mei and Jiang, Ming},
  journal      = {Pattern Recognition},
  year         = {2025},
  publisher    = {Elsevier}
}
