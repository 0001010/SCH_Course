grep_index <- grep('대$|대학$|대학교$|캠퍼스$',df$SearchWordss)
df2 <- df[grep_index,]

univer <- select(uni,시도,학교명,설립,본분교)

univer
names(univer) <-(c('시도','university','gubun','gubun2'))
univer <- subset(univer, gubun2=='본교')
df3 <-merge(df2,univer, by = 'university')

df3 <-df2 %>%inner_join(univer)



library(RColorBrewer)
rownames(df3) <- df3$시도
color<- factor(df3$시도)
color2<- factor(df3[df3$시도=='충남',]$gubun)
color2
jcol <-colorRampPalette(brewer.pal(8, "Set2"))(17)
names(jcol)<-unique(df3$시도)
color2

library(igraph)
g <- graph.data.frame(df3,directed = FALSE)
g
plot.igraph(g, layout = layout.auto, vertex.size =4, edge.width = 1, edge.arrow.size=.1,vertex.color = color2)
legend(x=-2.5,y = 1.2,names(jcol),pch=21, pt.bg = jcol,pt.cex = 2,cex = .8,bty = 'n',ncol=2)
g
Isolate <- which(degree(g)<2)
g_new = delete.vertices(g,Isolate)
g_new
length(Isolate)

g <- graph.data.frame(df3[df3$시도=='충남',],directed = FALSE)

tkplot(g_new)

which(table(edge.betweenness.community(g_new)$membership)>=2)
edge.betweenness.community(g_new)$membership
plot(edge.betweenness.community(g),g,layout = layout.auto, vertex.size =3, edge.width = 1,edge.arrow.size=1,asp = -1,vertex.label.cex=0.6)

# 전체적 특징
g <- graph.data.frame(df3,directed = FALSE)
Isolate <- which(degree(g)<2)
g_new = delete.vertices(g,Isolate)
plot.igraph(g_new, layout = layout.auto, vertex.size =4, edge.width = 1, edge.arrow.size=.1,vertex.color = jcol,vertex.label = NA)
legend(x=-2.5,y = 1.2,names(jcol),pch=21, pt.bg = jcol,pt.cex = 2,cex = .8,bty = 'n',ncol=2)

jcol <-colorRampPalette(brewer.pal(8, "Set2"))(26)
names(jcol)<-unique(edge.betweenness.community(g_new)$membership)
plot(edge.betweenness.community(g_new),g_new,layout = layout.auto, vertex.size =3, edge.width = 1,edge.arrow.size=1,asp = -1,vertex.label.cex=0.8,vertex.color=jcol)


##노드수
length(V(g))
length(E(g))


#####근접 중심성
closeness(g,mode="all")

####중개 중심성
g1 <- betweenness(g)
which.max(g1)

g2 <- eigen_centrality(g)
which.max(g2$vector)

s1 <-sort(degree(g),decreasing = TRUE)
which.max(s1)
which.min(s1)

###거리중심성
s2 <- sort(closeness(g,mode='all'),decreasing = T)
which.max(s2)
which.min(s2)

##중개 중심
s3 <- sort(betweenness(g),decreasing = T)
which.max(s3)
which.min(s3)

s4 <- eigen_centrality(g)
which.max(s4$vector)
which.min(s4$vector)

#중심성비교
sort(s4$vector,decreasing = T)
head(sort(s4$vector,decreasing = T),n=10)
head(sort(closeness(g,mode='all'),decreasing = T),n=10)
###밀도
edge_density(g)

##기초통계
length(V(g))
length(E(g))

##네트워크 연결성
edge_density(g)

####안정성
transitivity(g)
components(g)

##clique
head(cliques(g))

sort(sapply(cliques(g),length),decreasing = T)

largest_cliques(g)



# 충남의 특징
g <- graph.data.frame(df3[df3$시도=='충남',],directed = FALSE)
colorss

length(V(g))
length(E(g))
g
colorss <- factor((df3[df3$시도=='충남',]$university))
jcols <-colorRampPalette(brewer.pal(8, "Set1"))(14)
names(jcols)<-factor(unique(df3[df3$시도=='충남',]$university))
jcols<-jcols[V(g)]
colorss

plot.igraph(g, layout = layout.auto, vertex.size =8, edge.width = 3, edge.arrow.size=.2,vertex.color = jcols)

plot(edge.betweenness.community(g),g,layout = layout.auto, vertex.size =5, edge.width = 2,edge.arrow.size=1,asp = -1,vertex.label.cex=0.8)