library(datasets)
data("ToothGrowth")

#TESTING SUPP TYPE
#Two-sided t test 
t_test_supp <- t.test(len ~ supp, data = ToothGrowth)
#Two-sided t test, specify two sided
t.test(len ~ supp, data = ToothGrowth, alternative = "two.sided")
#Two-sided t test, assume equal variance
t_test_supp <- t.test(len ~ supp, data = ToothGrowth, alternative = "two.sided", var.equal = TRUE)

t_test_supp$p.value

#TESTING DOSAGE
#bonferroni
pairwise.t.test(ToothGrowth$len, ToothGrowth$dose, p.adjust.method = "bonferroni")

mean(ToothGrowth$len[ToothGrowth$supp == "OJ"]) - mean(ToothGrowth$len[ToothGrowth$supp == "VC"])


##ANOVA TEST - just to see what we should expect from t-tests with multiple testing
# Convert dose to a factor if it isn't already
ToothGrowth$dose <- as.factor(ToothGrowth$dose)
# Run one-way ANOVA for tooth growth by dose
anova_model <- aov(len ~ dose, data = ToothGrowth)
summary(anova_model)
# If ANOVA is significant, perform Tukey's post-hoc test for pairwise comparisons
tukey_results <- TukeyHSD(anova_model)
tukey_results

table(ToothGrowth$supp)

var(ToothGrowth$len[ToothGrowth$supp == "OJ"])
var(ToothGrowth$len[ToothGrowth$supp == "VC"])

# Using the formula interface
f_test_result <- var.test(len ~ supp, data = ToothGrowth)
print(f_test_result)

