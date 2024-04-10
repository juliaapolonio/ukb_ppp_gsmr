FROM quay.io/biocontainers/bioconductor-mungesumstats:1.10.1--r43hdfd78af_0

# Necessary libraries
RUN Rscript -e "install.packages('vroom', repos = 'http://cran.us.r-project.org')"
RUN Rscript -e "install.packages('dplyr', repos = 'http://cran.us.r-project.org')"

# Install necessary databases (GRCh38)
RUN Rscript -e "install.packages('BiocManager', repos = 'http://cran.us.r-project.org')"
RUN Rscript -e "options(timeout = 10000); BiocManager::install('SNPlocs.Hsapiens.dbSNP155.GRCh38')" && \
    Rscript -e "options(timeout = 10000); BiocManager::install('BSgenome.Hsapiens.NCBI.GRCh38')"

# Install necessary databases (GRCh37)
RUN Rscript -e "options(timeout = 10000); BiocManager::install('SNPlocs.Hsapiens.dbSNP155.GRCh37')" && \
    Rscript -e "options(timeout = 10000); BiocManager::install('BSgenome.Hsapiens.1000genomes.hs37d5')"


LABEL version="1.0" maintainer="apoloniojulia@gmail.com"

