# Vision-Driven Multimodal Traffic Forecasting and Proactive Signal Control in Non-Lane-Based Heterogeneous Networks

Official open-science data and code repository accompanying the manuscript submitted to *Transportation Research Part C: Emerging Technologies*:

> **Vision-Driven Multimodal Traffic Forecasting and Proactive Signal Control in Non-Lane-Based Heterogeneous Networks: A Detection Transformer and Correlation-Weighted Graph Framework**  
> Chinmoy Debnath Abir\*, Md. Foisal Mahmud Imran, Mst Ilme Faridatul  
> Department of Urban & Regional Planning, Rajshahi University of Engineering & Technology (RUET), Rajshahi-6204, Bangladesh

---

## Overview

This repository provides the anonymized 5-minute multimodal directional traffic count dataset extracted via **RF-DETR-Nano + ByteTrack** from 56 hours of 2560×1440 municipal CCTV footage at **C&B Crossroads, Rajshahi, Bangladesh** (Jan 25–31, 2026), together with the complete **PyTorch 3-seed chronological forecasting benchmark** and **HCM 2010 two-phase oversaturated control delay evaluation**.

Raw police CCTV video files are excluded to comply with Rajshahi Metropolitan Police (RMP) privacy and public-safety protocols.

## Repository Structure

```text
Rajshahi-Multimodal-Traffic-TGCN/
├── data/
│   └── csv_5min/                          # 53 anonymized 5-min RF-DETR directional flow CSVs (473 unique intervals)
├── notebooks/
│   └── 01_TRC_Correlation_TGCN_v3.ipynb   # Full 3-seed benchmark, ablations & HCM 2010 delay evaluation
├── results/
│   ├── tables/                            # Exported 3-seed benchmark and HCM 2010 summary CSVs
│   └── figures/                           # Publication-grade 300-DPI figures (Figs. 1–6)
├── requirements.txt
├── LICENSE
└── README.md
```

## Key Verified Results (58 Unseen Chronological Test Windows)

### 1. 3-Seed Spatiotemporal Forecasting Benchmark (Seeds: 42, 123, 2026)

| Forecasting Model | Veh MAE | Veh RMSE | PCU MAE (5-min) | PCU RMSE (5-min) | PCU MAPE (%) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Persistence (Last-Step) | 2.1518 ± 0.0000 | 5.3232 ± 0.0000 | 25.07 ± 0.00 | 46.78 ± 0.00 | 56.52 ± 0.00 |
| Static ST-GCN (Uniform 0.25) | 1.8219 ± 0.0408 | 4.3699 ± 0.1146 | 21.48 ± 0.37 | 36.73 ± 0.89 | 51.71 ± 0.99 |
| Historical Average (HA) | 2.0841 ± 0.0000 | 4.6873 ± 0.0000 | 20.97 ± 0.00 | 36.91 ± 0.00 | 56.49 ± 0.00 |
| ST-GCN (w/o Graph, A = I) | 1.7948 ± 0.0300 | 4.3920 ± 0.0705 | 20.30 ± 0.31 | 36.71 ± 0.51 | 51.80 ± 0.86 |
| Gated Corr-TGCN + Time | 1.8181 ± 0.0245 | 4.4085 ± 0.1432 | 19.96 ± 0.74 | 36.85 ± 0.77 | 51.03 ± 3.33 |
| LSTM (2-Layer Temporal) | 1.7738 ± 0.0265 | 4.4130 ± 0.0836 | 19.83 ± 0.47 | 36.58 ± 0.83 | 50.85 ± 1.84 |
| **Corr-Weighted T-GCN (Proposed)** | **1.7423 ± 0.0083** | **4.2692 ± 0.0859** | **19.38 ± 0.31** | **35.45 ± 0.66** | **48.81 ± 1.89** |

### 2. Operational Control Validation (HCM 2010 Two-Phase Arterial Timing)

| Signal Control Strategy | Mean Delay (s/veh) | Median Delay (s/veh) | P95 Delay (s/veh) | HCM LOS | Savings by Proposed |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Fixed-Time 50/50 (C = 120 s) | 233.75 | 259.19 | 353.64 | F | 74.38% (58/58, p < 0.001) |
| Fixed-Time 65/35 (C = 120 s) | 110.23 | 116.44 | 192.43 | F | 45.66% (58/58, p < 0.001) |
| Fixed-Time 75/25 (C = 120 s) | 67.60 | 69.55 | 143.46 | E | 11.40% (50/58, p < 0.001) |
| **Proposed Corr-Weighted T-GCN** | **59.90** | **57.44** | **136.54** | **E** | — |
| Oracle Perfect-Foresight Bound | 57.46 | 53.31 | 147.55 | E | (+2.44 s/veh gap) |

## Quickstart & Reproducibility

```bash
git clone https://github.com/ChinmoyDn818/Rajshahi-Multimodal-Traffic-TGCN.git
cd Rajshahi-Multimodal-Traffic-TGCN
pip install -r requirements.txt
jupyter notebook notebooks/01_TRC_Correlation_TGCN_v3.ipynb
```

Running `notebooks/01_TRC_Correlation_TGCN_v3.ipynb` top-to-bottom automatically loads the anonymized CSVs from `data/csv_5min/`, stitches the 12 chronological recording sessions (377 windows), trains and evaluates all 7 models across 3 random seeds, and reproduces the HCM 2010 control delay tables and figures.

## License

- **Source Code:** MIT License (see `LICENSE`).
- **Anonymized Traffic Count Dataset (`data/csv_5min/`):** CC BY 4.0.
