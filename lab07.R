# The MIT License (MIT)
# 
#   Copyright (c) 2016 Wei-Hung Weng
# 
#   Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE. 
# 
# Title : BMI701 Lab 7: ggplot and shiny
# Author : Wei-Hung Weng
# Created : 10/25/2016
# Comment : 

# List of packages for session
.packages <- c("ggplot2")
# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])
# Load packages into session 
lapply(.packages, library, character.only=TRUE)


#install.packages("HistData")
library(HistData)
library(scales)
data(Minard.troops)
data(Minard.cities)
ggplot(Minard.troops, aes(long, lat)) + 
  geom_path(aes(size=survivors, color = direction, group = group, lineend="round")) + 
  geom_text(aes(label = city), size = 3, data = Minard.cities)


data(diamonds)
d <- diamonds[order(diamonds$price, decreasing=TRUE), ]
d <- d[1:1000, ]
head(d)

hist(d$price)
plot(d)
plot(d, cut, price)

ggplot(d, aes(clarity, fill=cut)) +
  geom_bar()

ggplot(d, aes(x=cut, y=price)) +
  geom_point()


ggplot(d, aes(x=carat, y=price)) +
  geom_point()

ggplot(d, aes(x=cut, y=price)) +
  geom_jitter()

ggplot(d, aes(x=cut, y=price)) +
  geom_boxplot()

ggplot(d, aes(x=cut, y=price)) + 
  geom_boxplot(outlier.size=0) + 
  geom_jitter(position= position_jitter(h=.1))


ggplot(d, aes(x=cut, y=price, fill=cut)) +
  geom_violin()

ggplot(d, aes(x=cut, y=price, color=cut)) +
  geom_violin() +
  geom_boxplot(width=0.3)


# density plot
ggplot(d, aes(x=carat, fill=cut)) +
  geom_line(stat="density")

ggplot(d, aes(x=carat, fill=cut)) +
  geom_density(alpha=0.3)


ggplot(d, aes(x=carat, y=price)) + 
  geom_point() + 
  facet_wrap (~clarity, ncol=2)

ggplot(d, aes(x=carat, y=price)) + 
  geom_point() + 
  facet_grid(cut~clarity)

ggplot(d, aes(x=carat, y=price, color=cut)) + 
  geom_point()

ggplot(d, aes(x=carat, y=price, color=cut)) + 
  geom_point() + 
  stat_smooth(method="gam", fill=NA, color="purple")

ggplot(d, aes(x=carat, y=price, color=cut)) + 
  geom_point() + 
  scale_y_continuous(limits=c(15000, 20000)) +
  stat_smooth(method="gam", fill=NA, color="purple")


ggplot(d, aes(x=carat, y=price, color=cut)) + 
  geom_point() + 
  stat_smooth(method="gam", fill=NA, color="purple", linetype="dashed", geom="ribbon")

ggplot(d, aes(x=carat, y=price, color=cut)) + 
  geom_point(alpha=0.3) + 
  geom_smooth()


# 
p <- ggplot(d, aes(x=cut, y=price))
p + 
  geom_jitter() + 
  ggtitle("Title") + 
  xlab("X-axis") + 
#  scale_x_continuous(breaks=seq(50, 80, by=5), labels=c(50,"fifty-five",60,65,70,75,80)) +
  ylab("Y-axis") + 
  theme(title=element_text(color="blue", size=30),
        axis.title.x=element_text(size=14, color="green", face="bold"),
        axis.title.y=element_text(size=14, color="blue"),
        axis.text.x=element_text(size=12, color="purple"),
        axis.text.y=element_text(size=12, color="yellow"),
        axis.ticks.y=element_blank())

p + 
  geom_jitter() + 
  ggtitle("Title") + 
  xlab("X-axis") + 
  #  scale_x_continuous(breaks=seq(50, 80, by=5), labels=c(50,"fifty-five",60,65,70,75,80)) +
  ylab("Y-axis") + 
  theme(title=element_text(color="blue", size=30),
        axis.title.x=element_text(size=14, color="green", face="bold"),
        axis.title.y=element_text(size=14, color="blue"),
        axis.text.x=element_text(size=12, color="purple"),
        axis.text.y=element_text(size=12, color="yellow"),
        axis.ticks.y=element_blank()) +
  theme_minimal() # gray, classic, bw, minimal


p + 
  geom_jitter() + 
  theme_minimal() + # gray, classic, bw, minimal
  ggtitle("Title") + 
  xlab("X-axis") + 
  #  scale_x_continuous(breaks=seq(50, 80, by=5), labels=c(50,"fifty-five",60,65,70,75,80)) +
  ylab("Y-axis") + 
  theme(title=element_text(color="blue", size=30),
        axis.title.x=element_text(size=14, color="green", face="bold"),
        axis.title.y=element_text(size=14, color="blue"),
        axis.text.x=element_text(size=12, color="purple"),
        axis.text.y=element_text(size=12, color="yellow"),
        axis.ticks.y=element_blank())


setwd("~/Desktop/")
png("test.png", width=800, height=600)
p <- ggplot(d, aes(x=cut, y=price))
p + 
  geom_jitter() + 
  ggtitle("Title") + 
  xlab("X-axis") + 
  #  scale_x_continuous(breaks=seq(50, 80, by=5), labels=c(50,"fifty-five",60,65,70,75,80)) +
  ylab("Y-axis") + 
  theme(title=element_text(color="blue", size=30),
        axis.title.x=element_text(size=14, color="green", face="bold"),
        axis.title.y=element_text(size=14, color="blue"),
        axis.text.x=element_text(size=12, color="purple"),
        axis.text.y=element_text(size=12, color="yellow"),
        axis.ticks.y=element_blank())
dev.off()
