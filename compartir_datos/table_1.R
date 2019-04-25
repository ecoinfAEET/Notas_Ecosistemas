
library(tidyverse)
library(here)
library(pander)
library(kableExtra)
library(knitr)
library(dplyr)
library(flextable)
library(officer)
library(here)
library(openxlsx)



d <- read.xlsx(here::here("data", "Table_1.xlsx"), "t1")
names(d)[3:7] <- c("if", "type", "ob", "cr", "pd")

d1 <- d %>% 
  separate("Revista", c("Revista", "Revista_href"), sep = "]") %>%
  separate("cr", c("cr", "cr_href"), sep = "]") %>% 
  separate("pd", c("pd", "pd_href"), sep = "]") %>% 
  mutate(Revista = str_sub(Revista, 2)) %>% 
  mutate(cr = str_sub(cr, 2)) %>% 
  mutate(pd = str_sub(pd, 2)) %>% 
  mutate(Revista_href = str_sub(Revista_href, 2, -2)) %>% 
  mutate(cr_href = str_sub(cr_href, 2, -2)) %>% 
  mutate(pd_href = str_sub(pd_href, 2, -2))  


t1 <- flextable(d1, col_keys = c("Ranking","Revista", "if", "type", "cr", "pd")) 

# colours         
t1 <- bg(t1, i = d1$ob == 1, j = "type", bg = "#70AD47")
t1 <- bg(t1, i = d1$ob == 2, j = "type", bg = "#FFC000")
t1 <- bg(t1, i = d1$ob == 3 , j = "type", bg = "#ED7D31")

# Col names 
t1 <- set_header_labels(t1, 
                        values = list("if" = "Factor de Impacto", 
                                      "type"= "Tipo de Artículo Principal",
                                      "cr" = "URL's útiles. Criterios de repositorio",
                                      "pd" = "URL's útiles. Política de datos"
                        ))

# Links
t1 <- compose(t1, j = "Revista", value = as_paragraph(hyperlink_text(x= Revista, url = Revista_href))) 
t1 <- compose(t1, j = "cr", value = as_paragraph(hyperlink_text(x= cr, url = cr_href))) 
t1 <- compose(t1, j = "pd", value = as_paragraph(hyperlink_text(x= pd, url = pd_href))) 

# Others
t1 <- fontsize(t1, size = 7)
t1 <- colformat_num(t1, col_keys = "Ranking", digits = 0)
t1 <- autofit(t1) 


doc <- read_docx(path = here::here("ms/template_tables_portrait.docx"))
doc <- body_add_flextable(doc, value = t1) 
print(doc, target = here::here("ms/tables1.docx"))
