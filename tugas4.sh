#!/bin/bash

# 1. gabungkan kedua file
csvstack 2019-Oct-sample.csv 2019-Nov-sample.csv > 2019-Oct-Nov-sample.csv

# 2. seleksi kolom relevan dan reorder
csvcut -c 2,3,4,5,7,8,6 2019-Oct-Nov-sample.csv > 2019-Oct-Nov-sample-selected.csv

# 3. filter aktivitas purchase
csvgrep -c "event_type" -m "purchase" 2019-Oct-Nov-sample-selected.csv > 2019-Oct-Nov-sample-selected-filtered.csv

# 4. split kategori produk
# 4.1. memisahkan kolom category_code ke category_code.csv
csvcut -c 7 2019-Oct-Nov-sample-selected-filtered.csv > category_code.csv

# 4.2. dari category_code.csv ambil kata pertama sebelum titik dan simpan ke category.csv
cat category_code.csv | awk -F "." '{print $1}' > category.csv

# 4.3. dari category_code.csv ambil kata terakhir sebelum titik dan simpan ke product_name.csv
cat category_code.csv | awk -F "." '{print $NF}' > product_name.csv

#4.4. gabungkan file utama dengan category.csv
csvjoin 2019-Oct-Nov-sample-selected-filtered.csv category.csv > 2019-Oct-Nov-sample-selected-filtered-splitted.csv

#4.5. gabungkan lagi hasilnya dengan product_name.csv
csvjoin 2019-Oct-Nov-sample-selected-filtered-splitted.csv product_name.csv > 2019-Oct-Nov-sample-selected-filtered-splitted2.csv

#4.6. mengeluarkan kolom category_code awal dan simpan hasil ke 2019-Oct-Nov-sample-final.csvcut
csvcut -c 1,2,3,4,5,6,8,9 2019-Oct-Nov-sample-selected-filtered-splitted2.csv > 2019-Oct-Nov-sample-splitted3.csv

#4.7. rename 2 kolom terakhir dan simpan ke data_clean.csv
sed -e '1s/category_code2/category/' -e '1s/category_code2_2/product_name/' 2019-Oct-Nov-sample-splitted3.csv > data_clean.csv

