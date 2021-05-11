#!/usr/bin/env nextflow
/*
========================================================================================
    nf-core/rnaseq
========================================================================================
    Github : https://github.com/nf-core/rnaseq
    Website: https://nf-co.re/rnaseq
    Slack  : https://nfcore.slack.com/channels/rnaseq
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
========================================================================================
    GENOME PARAMETER VALUES
========================================================================================
*/

params.fasta        = WorkflowMain.getGenomeAttribute(params, 'fasta')
params.gtf          = WorkflowMain.getGenomeAttribute(params, 'gtf')
params.gff          = WorkflowMain.getGenomeAttribute(params, 'gff')
params.gene_bed     = WorkflowMain.getGenomeAttribute(params, 'bed12')
params.star_index   = WorkflowMain.getGenomeAttribute(params, 'star')
params.hisat2_index = WorkflowMain.getGenomeAttribute(params, 'hisat2')
params.rsem_index   = WorkflowMain.getGenomeAttribute(params, 'rsem')
params.salmon_index = WorkflowMain.getGenomeAttribute(params, 'salmon')

/*
========================================================================================
    VALIDATE & PRINT PARAMETER SUMMARY
========================================================================================
*/

WorkflowMain.initialise(workflow, params, log)

/*
========================================================================================
    NAMED WORKFLOW FOR PIPELINE
========================================================================================
*/

workflow NFCORE_RNASEQ {

    /*
     * WORKFLOW: Get SRA run information for public database ids, download and md5sum check FastQ files, auto-create samplesheet
     */
    if (params.public_data_ids) {
        include { SRA_DOWNLOAD } from './workflows/sra_download'
        SRA_DOWNLOAD ()

    /*
     * WORKFLOW: Run main nf-core/rnaseq analysis pipeline
     */
    } else {
        include { RNASEQ } from './workflows/rnaseq'
        RNASEQ ()
    }
}

/*
========================================================================================
    RUN ALL WORKFLOWS
========================================================================================
*/

/*
 * WORKFLOW: Execute a single named workflow for the pipeline
 * See: https://github.com/nf-core/rnaseq/issues/619
 */
workflow {
    NFCORE_RNASEQ ()
}

/*
========================================================================================
    THE END
========================================================================================
*/
