## This script predicts scores for each gymnast and apparatus.

#===============================================#
#=== player score distributions by apparatus ===#
#===============================================#

# create data frame to hold gymnast names, country, apparatus, score means and sds, and sample size
gymnast_dist <- data.frame()

# for each gymnast (unique name)
for (x in unique(later_scores$fullname)) {
  
  # grab that gymnast's events
  apparatus = unique(later_scores[later_scores$fullname == x, ]$apparatus)
  
  # for each apparatus
  for (y in apparatus) {
    
    # get scores for current gymnast and apparatus
    gymnast_apparatus_scores <- later_scores %>% filter(fullname == x & apparatus == y)
    
    # get sample size of each gymnast + apparatus combo
    sample_size <- as.numeric(length(gymnast_apparatus_scores$score))
    
    if (sample_size > 1 & sd(gymnast_apparatus_scores$score, na.rm=TRUE) != 0) {
      # take mean of scores
      dist_mean <- mean(gymnast_apparatus_scores$score)
    
      # calculate sd under CLT
      dist_sd <- sd(gymnast_apparatus_scores$score) / sqrt(sample_size)
      
      # create row of dataframe
      current_row <- data.frame("fullname" = x, "apparatus" = y, "mean" = dist_mean, "sd" = dist_sd, "sample_size" = sample_size)
      
      # stack onto df
      gymnast_dist <- rbind(gymnast_dist, current_row)
    }
  }
}
# Check mean squared error

later_scores$distscore <- NA
for (i in 1:nrow(later_scores)) {
  for (j in 1:nrow(gymnast_dist))
    if (later_scores$fullname[i] == gymnast_dist$fullname[j] & later_scores$apparatus[i] == gymnast_dist$apparatus[j]) {
      later_scores$distscore[i] <- gymnast_dist$mean[j]
    }
}

later_scores <- later_scores %>% 
                mutate(distscore = ifelse(is.na(distscore), 0, distscore))
#error = 4.86
sqrt(mean((later_scores$distscore - later_scores$score)^2))

# make histograms of gymnast distribution by apparatus
for (i in seq(1, nrow(gymnast_dist))) {
  
  # generate 10000 Gaussian deviates from mean and standard deviation
  data = rnorm(10000, mean = as.numeric(gymnast_dist[i, 'mean']), sd = as.numeric(gymnast_dist[i, 'sd']))

  # plot histogram with 20 bins
  hist(data, main = paste("Histogram of", paste0(gymnast_dist[i, 'fullname'], "'s"), gymnast_dist[i, 'apparatus'],
                          "Score Distribution"), xlab = "Scores", col = "blue", breaks = 20)
}

#============================#
#=== score prediction lms ===#
#============================#

# separate scores by gender and remove direct predictors of score
men_later_scores <- later_scores[later_scores$gender == "m", c(-1, -2, -3, -11, -12, -13)] # removing lastname, firstname, gender, e_score, d_score, penalty
women_later_scores <- later_scores[later_scores$gender == "w", c(-1, -2, -3, -11, -12, -13)] # removing lastname, firstname, gender, e_score, d_score, penalty

# models for men
men_lm_full <- lm(score ~ ., data = na.omit(men_later_scores))
men_lm0 <- lm(score ~ 1, data = na.omit(men_later_scores))
men_forward_AIC <- stepAIC(men_lm0, scope = formula(men_lm_full), direction = "forward", data = men_later_scores)
summary(men_forward_AIC)$adj.r.squared

k=5
folds=rep(1:k, length.out=nrow(men_later_scores))
men_later_scores$fold = sample(folds, nrow(men_later_scores), replace=F)

lm1 = lm(score ~ location + country, data = men_later_scores)
for(j in 1:k){
  cat(j, "")
  train.rows <- men_later_scores$fold!=j
  test.rows <- men_later_scores$fold==j
  
  
  lm1 = lm(score ~ location + country, data = men_later_scores)
  
  men_later_scores[test.rows,]$lm1 <- predict(lm1, newdata = men_later_scores[test.rows,], type = 'response', allow.new.levels = T)
  
}
# best AIC = 5155
men_forward_AIC <- stepAIC(men_lm0, scope = formula(men_lm_full), direction = "forward", data = men_later_scores)


men_later_scores <- men_later_scores %>% mutate(lm1 = if_else(is.na(lm1), 0, lm1)) %>% 
  mutate(score = if_else(is.na(score), 0, score))
# 0.22
sqrt(mean(men_later_scores$lm1 - men_later_scores$score)^2)

# models for women
women_lm_full <- lm(score ~ ., data = na.omit(women_later_scores))
women_lm0 <- lm(score ~ 1, data = na.omit(women_later_scores))
women_forward_AIC <- stepAIC(women_lm0, scope = formula(women_lm_full), direction = "forward", data = women_later_scores)
summary(women_forward_AIC)$adj.r.squared

lm2$factor_var <- as.numeric(as.character(lm2$factor_var))
k=5
folds=rep(1:k, length.out=nrow(women_later_scores))
women_later_scores$fold = sample(folds, nrow(women_later_scores), replace=F)

lm2 = lm(score ~ fullname + rank + competition + apparatus + round + date, data = women_later_scores)
for(j in 1:k){
  cat(j, "")
  train.rows <- women_later_scores$fold!=j
  test.rows <- women_later_scores$fold==j
  
  
  lm2 = lm(score ~ fullname + rank + competition + apparatus + round + date, data = women_later_scores)
  
  women_later_scores[test.rows,]$lm2 <- predict(lm2, newdata = women_later_scores[test.rows,], type = 'response', allow.new.levels = T)
  
}
women_forward_AIC <- stepAIC(women_lm0, scope = formula(women_lm_full), direction = "forward", data = women_later_scores)
women_later_scores <- women_later_scores %>% mutate(lm1 = if_else(is.na(lm1), 0, lm1)) %>% 
  mutate(score = if_else(is.na(score), 0, score))
sqrt(mean(women_later_scores$lm2 - women_later_scores$score)^2)
