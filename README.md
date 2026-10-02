# Advanced Regression for Housing Prices

Sam Castillo’s November 2018 write-up for the Kaggle House Prices competition (Ames, Iowa), from when he was a mathematics student at UMass Amherst.

**Live page:** https://sdcastillo.github.io/Kaggle-Advanced-Regression/

The training file has 1,460 homes and 81 columns. The test file has 1,459 homes. The modeling notebook counts 43 categorical fields and 38 numeric ones. Neighborhood names in `data_description.txt` sit inside the Ames city limits.

Both notebooks model `log(SalePrice + 1)` and score root mean squared error on that scale. Numeric predictors with absolute skew above 0.75 are shifted by one and Box–Cox transformed with lambda 0.15. Quality grades are releveled `None`, `Po`, `Fa`, `TA`, `Gd`, `Ex` before label encoding. The garage-quality boxplots are the before-and-after check.

Missing pool, alley, fence, fireplace, basement, and garage fields become `"None"`, and the matching areas and counts become 0. Lot frontage uses the neighborhood median. `Utilities` is dropped (one training level). `TotalSF` adds basement, first floor, and second floor. Two training sales with living area above 4,000 square feet and price under $400,000 are removed, plus one home with overall quality below 5 that sold above $200,000. Test ids stay. Remaining factors are dummy-coded, near-zero-variance columns are cut with `caret::nearZeroVar` (`freqCut = 95/10`), and numeric columns are scaled by median and interquartile range.

A linear model on lot area and overall quality lands near RMSE 0.21. Lasso (`glmnet`, alpha = 1) moves from 0.1088 to 0.0978 once the near-zero columns are gone. Elastic net’s cross-validation returns alpha 1. The XGBoost kept in the notebook uses learning rate 0.01, 2,500 rounds, depth 2, minimum child weight 3, column sample 0.4, and every row, with reported RMSE 0.0887. That single model beat the straight average of the lasso, the elastic net, and a caret GBM. The first lasso upload, 14 November 2018, sat near 4,000th on the public leaderboard. A `caretEnsemble` stack is left commented out.

## Takeaways

- RMSE is on `log(SalePrice + 1)`.
- Order quality grades None → Ex before integer encoding.
- Drop the two huge, cheap living-area sales from training only.
- Lasso RMSE: 0.1088, then 0.0978 after `nearZeroVar`.
- Kept XGBoost: eta 0.01, 2,500 trees, depth 2, reported RMSE 0.0887.

## Files

- [Modeling notebook](Kaggle%20-%20Advanced%20Regression%20for%20Housing%20Prices.Rmd) — the full fit, 13 November 2018.
- [Exploratory notebook](house%20prices%20-%20EDA.Rmd) and its [rendered HTML](house%20prices%20-%20EDA.nb.html). The HTML pass also sketches a random forest and a neural net.
- [label_encoding.R](label_encoding.R) — integer map for ordered factors, saved with `saveRDS`.
- [data_description.txt](data_description.txt) — Kaggle codebook.
- `train.csv`, `test.csv`, `sample_submission.csv`, `train_final.RDS`, `test_final.RDS`.
