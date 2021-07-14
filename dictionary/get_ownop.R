source(here::here('dictionary/utilities.R'))

url <- "https://www.nationsonline.org/oneworld/country_code_list.htm"

ownop_codes <- list("Country-Codes-A-C", "Country-Codes-D-H", "CountryCodes-I-L", "Country-Codes-M-P", "Country-Codes-Q-T", "Country-Codes-U-Z") %>%
  map_dfr(~url %>%
            read_html() %>%
            html_elements(paste0("#", .x)) %>%
            html_table() %>%
            extract2(1)) %>%
  select(-X1, -X3, -X4) %>%
  filter(nchar(X2) > 1 & X2 != "Y-Z") %>%
  rename(ownop = X2, iso3n = X5) %>%
  mutate(iso3n = if_else(ownop == "Sudan", 729, as.numeric(iso3n))) %>%
  left_join(codelist %>%
              select(country.name.en, iso3n) %>%
              mutate(iso3n = if_else(country.name.en == "Netherlands Antilles", 530, iso3n)) %>%
              rename(country = country.name.en),
            by = "iso3n") %>%
  select(-iso3n)


ownop_codes %>% write_csv('dictionary/data_ownop.csv', na = "")
