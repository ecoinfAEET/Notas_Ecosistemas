
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



d2 <- read.xlsx(here::here("data", "Table_2.xlsx"), "t2")

# format names



names(d2)[c(3,5,6,8,9,10)] <- c("rd","cat", "if","type", "npapers",
                         "first_year")

d2 <- d2 %>% mutate(Acceso = ifelse(Acceso == "Open Access", "OA", "H"))


t2 <- flextable(d2, col_keys = c("Revista","Acceso", "cat", "if", "type", 
                                 "Cuartil","npapers","first_year","Ejemplo",
                                 "instr","Plantilla","rep_int", "url")) 

# colours         
t2 <- bg(t2, i = d2$rep_rec == 1, j = "rep_int", bg = "#7fc97f")
t2 <- bg(t2, i = d2$rep_rec == 2, j = "rep_int", bg = "#beaed4")
t2 <- bg(t2, i = d2$rep_rec == 3 , j = "rep_int", bg = "#fdc086")
t2 <- bg(t2, i = d2$rep_rec == 4 , j = "rep_int", bg = "#ffff99")
t2 <- bg(t2, i = d2$rep_rec == 5 , j = "rep_int", bg = "#386cb0")


# Links
t2 <- compose(t2, j = "Revista", value = as_paragraph(hyperlink_text(x= Revista, url = Revista_href))) 
t2 <- compose(t2, j = "instr", value = as_paragraph(hyperlink_text(x= instr, url = instr_href))) 
t2 <- compose(t2, j = "Plantilla", value = as_paragraph(hyperlink_text(x= Plantilla, url = Plantilla_href))) 
t2 <- compose(t2, j = "url", value = as_paragraph(hyperlink_text(x= url, url = url_href))) 

 
# Col names 
t2 <- colformat_num(t2, col_keys = "first_year", digits = 0, big.mark = "")
t2 <- set_header_labels(t2, 
                        values = list("cat" = "Categorías JCR",
                                      "if" = "Factor de Impacto", 
                                      "type"= "Tipo de Artículo",
                                      "npapers" = "Número total de artículos de datos publicados",
                                      "first_year" = "Primer año de publicación de artículos de datos",
                                      "instr" = "Instrucciones para autores y secciones del artículo",
                                      "rep_int" = "Repositorios integrados*",
                                      "url" = "URL's útiles"))

t2 <- bold(t2, j = "Revista", i = ~ d2$rd == "Si", bold = TRUE, part = "body")
t2

doc <- read_docx(path = here::here("ms/template_tables_portrait.docx"))
doc <- body_add_flextable(doc, value = t2) 
print(doc, target = here::here("ms/tables2.docx"))
