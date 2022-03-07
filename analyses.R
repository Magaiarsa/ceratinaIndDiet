## load required libraries
library(tidyverse); library(broom); library(visreg); library(cowplot); library(performance); library(GGally)

################################
# read data ----
################################
inds.metrics <- read_csv("data.csv") %>%
  # make pop level variable
  separate(inds, into = c("pop","temp"), sep = 1, remove = F) %>%
  select(-temp)
inds.metrics ## checking that the data loaded

################################################################
## H1: specialization at the individual level, within and across populations ----
################################################################
lm_plant_psi <- lm(psis ~ pop, inds.metrics)
summary(lm_plant_psi)
anova(lm_plant_psi)
summary(update(lm_plant_psi, .~. -1))
TukeyHSD(aov(psis ~ pop, inds.metrics))

# Plotting Figure 1
ggplot(data = inds.metrics, aes(x = psis, y=pop, group=pop)) +
  geom_boxplot() + facet_grid(pop ~ ., scales = "free_y") +
  geom_point(aes(fill = pop)) +
  theme_bw() +
  theme(legend.position = "none",
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  ylab("") +
  xlab("Individual Proportional Similarity (Psi)")

################################################################
## H2: specialization x richness of microbial communities ----
################################################################
## bact psi models ----
# no rarefaction
lm_bact.notrare_psi <- lm(bact.rich.notrare ~ pop + psis, inds.metrics, contrasts = list(pop = "contr.sum"))
summary(lm_bact.notrare_psi)
anova(update(lm_bact.notrare_psi, .~. + pop:psis))
plot(update(lm_bact.notrare_psi, .~. + pop:psis)) # checking the model

# high read depth
lm_bact_psi <- lm(bact.rich ~ pop + psis, inds.metrics, contrasts = list(pop = "contr.sum"))
summary(lm_bact_psi)
anova(update(lm_bact_psi, .~. + pop:psis)) # no pop:psis effect
plot(update(lm_bact_psi, .~. + pop:psis)) # checking the model

# low read depth
lm_bact.2_psi <- lm(bact.rich.2 ~ pop + psis, inds.metrics, contrasts = list(pop = "contr.sum"))
summary(lm_bact.2_psi)
anova(update(lm_bact.2_psi, .~. + pop:psis)) # no pop:psis effect
plot(update(lm_bact.2_psi, .~. + pop:psis)) # checking the model

################################
## fungi psi models ----
# no rarefaction
lm_fungi.notrare_psi <- lm(fungi.rich.notrare ~ pop + psis + pop:psis, inds.metrics, contrasts = list(pop = "contr.sum"))
summary(lm_fungi.notrare_psi)
anova(update(lm_fungi.notrare_psi, .~. + pop:psis)) # no pop:psis effect
plot(update(lm_fungi.notrare_psi, .~. + pop:psis)) # checking the model

# high read depth
lm_fungi_psi <- lm(fungi.rich ~ pop + psis, inds.metrics, contrasts = list(pop = "contr.sum"))
summary(lm_fungi_psi)
anova(update(lm_fungi_psi, .~. + pop:psis)) # no pop:psis effect
plot(update(lm_fungi_psi, .~. + pop:psis)) # checking the model

# low read depth
lm_fungi.2_psi <- lm(fungi.rich.2 ~ pop + psis, inds.metrics, contrasts = list(pop = "contr.sum"))
summary(lm_fungi.2_psi)
anova(update(lm_fungi.2_psi, .~. + pop:psis)) # no pop:psis effect
plot(update(lm_fungi.2_psi, .~. + pop:psis)) # checking the model

## tidy models and plot effect sizes ----
# goal is to view effect size of specialization (psi) across different read depths and for fungi and bacteria
# only have to multiple by range of specialization to view effect size
tidy_fungi_psi <- broom::tidy(lm_fungi_psi, conf.int = T) %>% mutate(taxa = "Fungi", `Read depth` = "High") # 530
tidy_fungi.2_psi <- broom::tidy(lm_fungi.2_psi, conf.int = T) %>% mutate(taxa = "Fungi", `Read depth` = "Low") # 96
tidy_fungi.notrare_psi <- broom::tidy(lm_fungi.notrare_psi, conf.int = T) %>% mutate(taxa = "Fungi", `Read depth` = "NA")
tidy_bact_psi <- broom::tidy(lm_bact_psi, conf.int = T) %>% mutate(taxa = "Bacteria", `Read depth` = "High") # 153
tidy_bact.2_psi <- broom::tidy(lm_bact.2_psi, conf.int = T) %>% mutate(taxa = "Bacteria", `Read depth` = "Low") # 95
tidy_bact.notrare_psi <- broom::tidy(lm_bact.notrare_psi, conf.int = T) %>% mutate(taxa = "Bacteria", `Read depth` = "NA")

tidy_microbe_psi <- bind_rows(tidy_fungi_psi, tidy_fungi.2_psi, tidy_fungi.notrare_psi, tidy_bact_psi, tidy_bact.2_psi, tidy_bact.notrare_psi)
tidy_microbe_psi$`Read depth` <- factor(tidy_microbe_psi$`Read depth`, levels = c("NA", "High", "Low"))
rescale_psis_range <- function(x) x*0.4 # average range of psi of brood cells for a particular individual

# plot change in number of microbe species over a specified range of specialization (Fig. S8)
psis_effect_size <- tidy_microbe_psi %>%
  filter(term == "psis") %>%
  mutate_at(.vars = c("estimate","std.error","conf.low","conf.high"), .funs = rescale_psis_range) %>%
  ggplot(aes(x = taxa, y = estimate, shape = `Read depth`)) +
  geom_linerange(aes(ymin = estimate - std.error, ymax = estimate + std.error), size = 1.5, position = position_dodge(width = 0.2)) +
  geom_linerange(aes(ymin = conf.low, ymax = conf.high), position = position_dodge(width = 0.2)) +
  geom_point(size = 4, position = position_dodge(width = 0.2)) +
  ylab(expression(Delta*"microbe species richness")) +
  xlab("") +
  geom_hline(yintercept = 0, linetype = "dotted") +
  ggtitle("PSi range = 0.4") +
  theme_cowplot()
psis_effect_size


###############################################################################
## H3: dietary breadth (centrality) x richness of microbial communities ----
###############################################################################

ggplot(inds.metrics, aes(x = degree, y = weighted.closeness, color = pop)) + geom_point() + geom_smooth(method = "lm")
summary(lm(weighted.closeness ~ pop + degree, data = inds.metrics))

# this indicates that if we know the population identity and the individual's degree, then we can do a pretty good job of predicting its centrality.
# this indicates that models with all three covariates will be highly collinear.
# therefore, any effect of centrality could also be due to its degree and among population differences in centrality.
# specifying degree as a covariate will isolate the direct effects of centrality.

################################
## bact centrality models ----
# not rarefied
lm_bact.notrare_wc <- lm(terms(bact.rich.notrare ~ pop*degree + weighted.closeness + pop:weighted.closeness, keep.order = T), inds.metrics)
anova(lm_bact.notrare_wc)
plot(lm_bact.notrare_wc)
lm_bact.notrare_wc_plot <- update(lm_bact.notrare_wc, .~. -1 -weighted.closeness -degree)

# high read depth
lm_bact_wc <- lm(terms(bact.rich ~ pop*degree + weighted.closeness + pop:weighted.closeness, keep.order = T), inds.metrics)
anova(lm_bact_wc)
plot(lm_bact_wc)
lm_bact_wc_plot <- update(lm_bact_wc, .~. -1 -weighted.closeness -degree)

# low read depth
lm_bact.2_wc <- lm(terms(bact.rich.2 ~ pop*degree + weighted.closeness + pop:weighted.closeness, keep.order = T), inds.metrics)
anova(lm_bact.2_wc)
plot(lm_bact.2_wc) # looks okay
lm_bact.2_wc_plot <- update(lm_bact.2_wc, .~. -1 -weighted.closeness -degree)

################################
## fungi centrality models ----
# not rarefied
lm_fungi.notrare_wc <- lm(terms(fungi.rich.notrare ~ pop*degree + weighted.closeness + pop:weighted.closeness, keep.order = T), inds.metrics)
anova(lm_fungi.notrare_wc) # pop:wc effect
plot(lm_fungi.notrare_wc) # looks okay
lm_fungi.notrare_wc_plot <- update(lm_fungi.notrare_wc, .~. -1 -weighted.closeness -degree)

# high read depth
lm_fungi_wc <- lm(terms(fungi.rich ~ pop*degree + weighted.closeness + pop:weighted.closeness, keep.order = T), inds.metrics)
anova(lm_fungi_wc) # pop:wc effect 0.06
plot(lm_fungi_wc) # looks okay
lm_fungi_wc_plot <- update(lm_fungi_wc, .~. -1 -weighted.closeness -degree)

# reproduce left panel of Fig. 2
visreg(lm_fungi_wc_plot, xvar = "weighted.closeness", by = "pop", breaks = c("V"), strip.names = c("Victoria"), cond = list(degree = 10), gg = T, line = list(col = "black"), points = list(size=4)) +
  xlab("Centrality (weighted-closeness)") +
  ylab("Fungi OTU Rarefied Richness") +
  theme_cowplot()

# low read depth
lm_fungi.2_wc <- lm(terms(fungi.rich.2 ~ pop*degree + weighted.closeness + pop:weighted.closeness, keep.order = T), inds.metrics)
anova(lm_fungi.2_wc) # pop:wc effect
plot(lm_fungi.2_wc)
check_model(lm_fungi.2_wc, check="outliers") # one outlier
plot(lm_fungi.2_wc, which = 4) # point 19
anova(update(lm_fungi.2_wc, data = inds.metrics[-19,])) # result is robust to removing point 19
plot(update(lm_fungi.2_wc, data = inds.metrics[-19,])) # all okay now
lm_fungi.2_wc_plot <- update(lm_fungi.2_wc, .~. -1 -weighted.closeness -degree)

################################
## tidy models and plot effect sizes ----
# goal is to view effect size of centrality (weighted closeness) across different read depths and for fungi and bacteria
# only have to multiple by range of specialization to view effect size
tidy_fungi_wc_plot <- broom::tidy(lm_fungi_wc_plot, conf.int = T) %>% mutate(taxa = "Fungi", `Read depth` = "High") # 530
tidy_fungi.2_wc_plot <- broom::tidy(lm_fungi.2_wc_plot, conf.int = T) %>% mutate(taxa = "Fungi", `Read depth` = "Low") # 96
tidy_fungi.notrare_wc_plot <- broom::tidy(lm_fungi.notrare_wc_plot, conf.int = T) %>% mutate(taxa = "Fungi", `Read depth` = "NA")
tidy_bact_wc_plot <- broom::tidy(lm_bact_wc_plot, conf.int = T) %>% mutate(taxa = "Bacteria", `Read depth` = "High") # 153
tidy_bact.2_wc_plot <- broom::tidy(lm_bact.2_wc_plot, conf.int = T) %>% mutate(taxa = "Bacteria", `Read depth` = "Low") # 95
tidy_bact.notrare_wc_plot <- broom::tidy(lm_bact.notrare_wc_plot, conf.int = T) %>% mutate(taxa = "Bacteria", `Read depth` = "NA")

tidy_microbe_wc_plot <- bind_rows(tidy_fungi_wc_plot, tidy_fungi.2_wc_plot, tidy_fungi.notrare_wc_plot, tidy_bact_wc_plot, tidy_bact.2_wc_plot, tidy_bact.notrare_wc_plot)
tidy_microbe_wc_plot$`Read depth` <- factor(tidy_microbe_wc_plot$`Read depth`, levels = c("NA", "High", "Low"))
summary(inds.metrics$weighted.closeness) # 1st to 3rd quartile range is about 0.04
group_by(inds.metrics, pop) %>%
  summarise(mean = mean(weighted.closeness), min = min(weighted.closeness), max = max(weighted.closeness)) %>%
  mutate(max - min) # typical range for each population is also about 0.04
rescale_wc_range <- function(x) x*0.04 # typical range of weighted closeness centrality

# plot change in number of microbe species over a specified range of specialization (Fig. S10)
wcs_effect_size <- tidy_microbe_wc_plot %>%
  filter(grepl(":weighted.closeness$", term)) %>%
  mutate_at(.vars = c("estimate","std.error","conf.low","conf.high"), .funs = rescale_wc_range) %>%
  separate(term, into = c("pop","wc"), sep = ":") %>%
  select(-wc) %>%
  ggplot(aes(x = pop, y = estimate, shape = `Read depth`)) +
  geom_linerange(aes(ymin = estimate - std.error, ymax = estimate + std.error), size = 1.5, position = position_dodge(width = 0.5)) +
  geom_linerange(aes(ymin = conf.low, ymax = conf.high), position = position_dodge(width = 0.5)) +
  geom_point(size = 4, position = position_dodge(width = 0.5)) +
  ylab(expression(Delta*"microbe species richness")) +
  xlab("") +
  scale_x_discrete(name = "", labels = c("Queensland", "South Australia", "Victoria")) +
  geom_hline(yintercept = 0, linetype = "dotted") +
  facet_wrap(~taxa, nrow = 2, scales = "free_y") +
  ggtitle("Weighted-closeness centrality range = 0.04") +
  theme_cowplot()
wcs_effect_size

