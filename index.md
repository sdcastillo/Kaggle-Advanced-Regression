---
layout: default
title: Advanced Regression for Housing Prices
tagline: Ames sale prices on the log scale, from a two-covariate line to a tuned XGBoost.
description: Sam Castillo on Kaggle contests in 2016, a custom-built AMD PC, the November 2018 Ames house-price notebooks, and machine-learning videos on Predictive Insights AI.
author: Sam Castillo
keywords: "Kaggle, competitive machine learning, House Prices, Ames Iowa, advanced regression, XGBoost, lasso, elastic net, GLM, decision trees, bias variance, R, statistics, YouTube, Predictive Insights AI, Sam Castillo, UMass Amherst, custom PC, AMD, GPU, CPU, RAM, 2016, Black Friday, Staples computer sales, artificial intelligence, superintelligence, SI"
hashtags: "#Kaggle #Kaggle2016 #CompetitiveML #HousePrices #AdvancedRegression #AmesHousing #XGBoost #Lasso #MachineLearning #Statistics #GLM #RStats #YouTube #CustomPC #AMD #GPU #artificialintelligence #superintelligence #SI"
youtube: "https://www.youtube.com/@predictiveanalyst"
samwiki: true
---

<section class="sw-section" id="early-kaggle">
  <div class="sw-section-head">
    <h2>Early on Kaggle <span class="sw-pill">2016</span></h2>
    <p>A note from Sam Castillo.</p>
  </div>
  <div class="sw-lede-copy">
    <p>I was really early into Kaggle. In 2016 I was participating in competitive machine-learning competitions on Kaggle, and I was training the models myself. The work ran on a custom-built PC: a GPU and a CPU, AMD chips, RAM, and the advanced processing I had put together so the fits could run at home.</p>
    <p>I had a job at Staples in computer sales at the same time. Black Friday went late. I was up late those nights on the sales floor, with computers, and still in the competitions.</p>
    <p>The notebooks below are the later write-up of that same practice. On 13 November 2018, while I was a mathematics student at UMass Amherst, I fitted the Ames House Prices data: log sale price, a lasso, an elastic net, and a tuned XGBoost. The first contests were already two years behind me.</p>
    <p class="sw-jumps" aria-label="Hashtags">
      <a href="https://github.com/topics/kaggle">#Kaggle</a>
      <a href="https://github.com/topics/machine-learning">#CompetitiveML</a>
      <a href="https://github.com/topics/kaggle">#Kaggle2016</a>
      <a href="https://github.com/topics/xgboost">#XGBoost</a>
      <a href="https://github.com/topics/r">#RStats</a>
      <a href="https://github.com/topics/data-science">#HousePrices</a>
      <a href="https://github.com/topics/machine-learning">#MachineLearning</a>
      <a href="https://github.com/topics/hardware">#CustomPC</a>
      <a href="https://github.com/topics/amd">#AMD</a>
      <a href="https://github.com/topics/gpu">#GPU</a>
    </p>
  </div>
</section>

<div class="sw-lede">
  <div class="sw-lede-copy">
    <h2>What the notebooks fit</h2>
    <p>Sam Castillo wrote this on 13 November 2018 for the Kaggle House Prices competition, while he was a mathematics student at UMass Amherst. The tables are the Ames, Iowa sales from that contest: 1,460 homes in <code>train.csv</code> and 1,459 homes in <code>test.csv</code>. The training file has 81 columns. The modeling notebook counts 43 categorical fields and 38 numeric ones, covering size, quality, neighborhood, and the terms of the sale. Neighborhood names in the codebook sit inside the Ames city limits. The long R Markdown file is the modeling argument. The rendered HTML notebook is the exploratory pass over the same files.</p>
    <p>Both notebooks model <code>log(SalePrice + 1)</code> and score root mean squared error on that scale. Raw sale price is right-skewed; the log pulls the histogram and the normal quantile plot into a shape a linear model can use. Numeric predictors with absolute skew above 0.75 are shifted by one and Box–Cox transformed with lambda 0.15. Quality fields that arrive unordered — fireplace, basement, kitchen, exterior, garage, pool, heating — are releveled <code>None</code>, <code>Po</code>, <code>Fa</code>, <code>TA</code>, <code>Gd</code>, <code>Ex</code> and then label-encoded. The garage-quality boxplots are the check: after releveling, the boxes step up with price.</p>
    <p>Most missing cells mean the feature is absent. Pool, alley, fence, fireplace, basement, and garage quality become the level <code>"None"</code>, and the matching areas and counts become 0. Lot frontage is filled with the median frontage in that neighborhood. <code>Utilities</code> is dropped because training has a single level. <code>TotalSF</code> adds basement, first-floor, and second-floor area. Two training sales with living area above 4,000 square feet and price under $400,000 are removed, along with one home of overall quality below 5 that sold above $200,000. The test file still carries every id, because the Kaggle submission has to. Remaining factors are dummy-coded, near-zero-variance columns are cut with <code>caret::nearZeroVar</code> (<code>freqCut = 95/10</code>), and numeric columns are centered at the median and divided by the interquartile range. When that range is 0, the scale falls back to the standard deviation.</p>
    <p>The first fit is a linear model of log price on lot area and overall quality, with 5-fold cross-validation. The notebook puts that RMSE near 0.21. Lasso, <code>glmnet</code> with alpha fixed at 1, is the next real model: the notes record RMSE 0.1088 before those near-zero columns are removed and 0.0978 after. An elastic net allowed to choose alpha walks the choice back to 1, so it repeats the lasso. A caret gradient boosting machine is tuned on interaction depth, tree count, shrinkage, and minimum node size. XGBoost is then tuned in stages. The grid’s lowest training error, learning rate 0.05 with 1,000 rounds, bends against the learning curves, so the notebook sets it aside and keeps learning rate 0.01, 2,500 rounds, depth 2, minimum child weight 3, a column sample of 0.4, and every row. The reported RMSE for that booster is 0.0887, lower than the straight average of the lasso, the elastic net, and the caret GBM.</p>
    <p>The first file sent to Kaggle, a lasso on 14 November 2018, landed near 4,000th on the public leaderboard. The XGBoost submission written in the notebook is dated 17 November 2018. A <code>caretEnsemble</code> stack is drafted in the source and left commented out; the blend written to disk is the unweighted average of those three base models. <code>label_encoding.R</code> is the small closure that maps a factor onto the sorted levels it was built with, then round-trips through <code>saveRDS</code>. <code>train_final.RDS</code> and <code>test_final.RDS</code> are the matrices after the pipeline.</p>
  </div>
  <aside class="sw-find" aria-label="Takeaways">
    <h2>Takeaways</h2>
    <ul>
      <li><strong>Score the log price</strong> RMSE is on log(SalePrice + 1). The training file has 1,460 rows; the test file has 1,459.</li>
      <li><strong>Order the grades first</strong> Encode None, Po, Fa, TA, Gd, Ex so the integers follow quality.</li>
      <li><strong>Two training outliers</strong> Living area above 4,000 square feet and price under $400,000, plus one overall-quality-below-5 sale above $200,000. Test ids stay.</li>
      <li><strong>Lasso moves 0.1088 to 0.0978</strong> That drop is from cutting near-zero-variance columns. Elastic net’s chosen alpha is 1.</li>
      <li><strong>Kept XGBoost</strong> eta 0.01, 2,500 rounds, depth 2, min child weight 3, column sample 0.4, subsample 1. Reported RMSE 0.0887.</li>
    </ul>
  </aside>
</div>

<section class="sw-section" id="notebooks">
  <div class="sw-section-head">
    <h2>Notebooks <span class="sw-pill">R</span></h2>
    <p>The modeling write-up, the rendered exploratory pass, and the field list. Training and test CSVs stay in the repository root next to the RDS matrices.</p>
  </div>
  <div class="sw-grid">
    <article class="sw-card">
      <div class="sw-card-top">
        <h3 class="sw-name">Modeling notebook</h3>
        <span class="sw-lang">R Markdown</span>
      </div>
      <p class="sw-desc">Skewness, ordered quality grades, missingness, outliers, lasso, elastic net, GBM, and the XGBoost grid. Dated 13 November 2018.</p>
      <p class="sw-meta">Kaggle - Advanced Regression for Housing Prices.Rmd</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-source" href="https://github.com/sdcastillo/Kaggle-Advanced-Regression/blob/master/Kaggle%20-%20Advanced%20Regression%20for%20Housing%20Prices.Rmd">View source</a>
      </div>
    </article>
    <article class="sw-card">
      <div class="sw-card-top">
        <h3 class="sw-name">Exploratory notebook</h3>
        <span class="sw-lang">HTML</span>
      </div>
      <p class="sw-badge">Rendered</p>
      <p class="sw-desc">The earlier pass, already knitted. Same cleaning, with sketches of a random forest and a neural net beside the regression path.</p>
      <p class="sw-meta">house prices - EDA.nb.html</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-live" href="house%20prices%20-%20EDA.nb.html">Open notebook</a>
        <a class="sw-btn sw-btn-source" href="https://github.com/sdcastillo/Kaggle-Advanced-Regression/blob/master/house%20prices%20-%20EDA.Rmd">View source</a>
      </div>
    </article>
    <article class="sw-card">
      <div class="sw-card-top">
        <h3 class="sw-name">Encoder and codebook</h3>
        <span class="sw-lang">R</span>
      </div>
      <p class="sw-desc">label_encoding.R builds an integer map from the levels it has seen. data_description.txt is the Kaggle field list, including the Ames neighborhoods.</p>
      <p class="sw-meta">Also in the root: train.csv, test.csv, sample_submission.csv</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-source" href="https://github.com/sdcastillo/Kaggle-Advanced-Regression/blob/master/label_encoding.R">Encoder</a>
        <a class="sw-btn sw-btn-live" href="data_description.txt">Codebook</a>
      </div>
    </article>
  </div>
</section>

<section class="sw-section" id="youtube">
  <div class="sw-section-head">
    <h2>On YouTube <span class="sw-pill">ML · AI · stats</span></h2>
    <p>Lessons from Sam Castillo’s channel, Predictive Insights AI. The same models as these notebooks: generalized linear models, trees, and the bias-variance tradeoff.</p>
  </div>
  <div class="sw-actions" style="margin-bottom: 1rem;">
    <a class="sw-btn sw-btn-live" href="https://www.youtube.com/@predictiveanalyst">Open the channel</a>
    <a class="sw-btn sw-btn-source" href="https://www.youtube.com/playlist?list=PL5fwmyo89ICYJNJhAg5dfZD0VpXpJL-ak">ML and stats playlist</a>
  </div>
  <div class="sw-grid">
    <article class="sw-card">
      <a href="https://www.youtube.com/watch?v=tSIddgdqnNM"><img class="sw-thumb" src="https://i.ytimg.com/vi/tSIddgdqnNM/hqdefault.jpg" alt="Thumbnail for Bias or Variance? The Machine-Learning Trade-Off Explained With One Bowling Strike" width="480" height="360"></a>
      <div class="sw-card-top">
        <h3 class="sw-name"><a href="https://www.youtube.com/watch?v=tSIddgdqnNM">Bias or variance</a></h3>
        <span class="sw-lang">ML</span>
      </div>
      <p class="sw-desc">The machine-learning tradeoff, told with one bowling strike. On Predictive Insights AI, October 2026.</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-live" href="https://www.youtube.com/watch?v=tSIddgdqnNM">Watch</a>
      </div>
    </article>
    <article class="sw-card">
      <a href="https://www.youtube.com/watch?v=xDJXuoM6ZCI"><img class="sw-thumb" src="https://i.ytimg.com/vi/xDJXuoM6ZCI/hqdefault.jpg" alt="Thumbnail for Mastering GLM Link Functions" width="480" height="360"></a>
      <div class="sw-card-top">
        <h3 class="sw-name"><a href="https://www.youtube.com/watch?v=xDJXuoM6ZCI">GLM link functions</a></h3>
        <span class="sw-lang">Stats</span>
      </div>
      <p class="sw-desc">Generalized linear models past the identity link: binomial, Poisson, and gamma. The housing lasso is the Gaussian cousin of this lesson.</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-live" href="https://www.youtube.com/watch?v=xDJXuoM6ZCI">Watch</a>
      </div>
    </article>
    <article class="sw-card">
      <a href="https://www.youtube.com/watch?v=J-LLoESGXnA"><img class="sw-thumb" src="https://i.ytimg.com/vi/J-LLoESGXnA/hqdefault.jpg" alt="Thumbnail for Decoding Decision Trees for Machine Learning" width="480" height="360"></a>
      <div class="sw-card-top">
        <h3 class="sw-name"><a href="https://www.youtube.com/watch?v=J-LLoESGXnA">Decision trees</a></h3>
        <span class="sw-lang">ML</span>
      </div>
      <p class="sw-desc">How a decision tree splits, which is the base learner inside the gradient booster in the housing notebook.</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-live" href="https://www.youtube.com/watch?v=J-LLoESGXnA">Watch</a>
      </div>
    </article>
    <article class="sw-card">
      <a href="https://www.youtube.com/watch?v=FE5-pKaBHrg"><img class="sw-thumb" src="https://i.ytimg.com/vi/FE5-pKaBHrg/hqdefault.jpg" alt="Thumbnail for Cost Complexity Pruning" width="480" height="360"></a>
      <div class="sw-card-top">
        <h3 class="sw-name"><a href="https://www.youtube.com/watch?v=FE5-pKaBHrg">Cost-complexity pruning</a></h3>
        <span class="sw-lang">ML</span>
      </div>
      <p class="sw-desc">Pruning a tree so it stops fitting noise. The same idea as the depth and learning-rate choices in the XGBoost grid.</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-live" href="https://www.youtube.com/watch?v=FE5-pKaBHrg">Watch</a>
      </div>
    </article>
    <article class="sw-card">
      <a href="https://www.youtube.com/watch?v=tHxeKVQP1oA"><img class="sw-thumb" src="https://i.ytimg.com/vi/tHxeKVQP1oA/hqdefault.jpg" alt="Thumbnail for Data Exploration in R for Bank Loans" width="480" height="360"></a>
      <div class="sw-card-top">
        <h3 class="sw-name"><a href="https://www.youtube.com/watch?v=tHxeKVQP1oA">Data exploration in R</a></h3>
        <span class="sw-lang">R</span>
      </div>
      <p class="sw-desc">A walk through an R exploration, the same first move as the histograms and missingness charts in these notebooks.</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-live" href="https://www.youtube.com/watch?v=tHxeKVQP1oA">Watch</a>
      </div>
    </article>
    <article class="sw-card">
      <a href="https://www.youtube.com/watch?v=R5H90R8ssAI"><img class="sw-thumb" src="https://i.ytimg.com/vi/R5H90R8ssAI/hqdefault.jpg" alt="Thumbnail for Live Webinar: Exam PA Machine Learning Secrets" width="480" height="360"></a>
      <div class="sw-card-top">
        <h3 class="sw-name"><a href="https://www.youtube.com/watch?v=R5H90R8ssAI">Exam PA live webinar</a></h3>
        <span class="sw-lang">ML</span>
      </div>
      <p class="sw-desc">A live session on the machine-learning material in the Society of Actuaries predictive analytics exam.</p>
      <div class="sw-actions">
        <a class="sw-btn sw-btn-live" href="https://www.youtube.com/watch?v=R5H90R8ssAI">Watch</a>
      </div>
    </article>
  </div>
</section>
