/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CONFIG FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

reads = Channel.fromPath('/storages/acari/julia.amorim/qtls/pqtl/teste_nf/*.tar')
reference = Channel.fromPath("/storages/acari/julia.amorim/references/plink_bfile/EUR_phase3_chr*")
reference.map { it -> it.getBaseName() }.unique().collectFile(name: "gsmr.input.txt", newLine:true).collect().set { ref_file }
reference.collect().set { collected_ref }
outcome = "/storages/acari/julia.amorim/qtls/SDEP_rsID.txt"
sumstats = file("/data/home/julia.amorim/scripts/data/sumstats/MTAG_depression_sumstats_hg38.txt")


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { UNTAR } from "./modules/nf-core/untar/main.nf"
include { MERGE } from "./modules/local/merge_file/merge_file.nf"
include { R_LIFT } from "./modules/local/r_lift/rscript_format.nf"
include { GCTA_GSMR } from "./modules/local/gcta_gsmr/gsmr.nf"


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


workflow {

    UNTAR (
        reads
    )

    MERGE (
        UNTAR.out.untar
    )

    R_LIFT (
        MERGE.out.merged,
        sumstats
    )

    GCTA_GSMR (
        R_LIFT.out.lifted,
        collected_ref,
        outcome,
        ref_file
    )
}
