ARG BASE_IMAGE

FROM $BASE_IMAGE

ENV generic_batch_job /generic_batch_job
RUN rm -r $generic_batch_job; mkdir $generic_batch_job
WORKDIR $generic_batch_job
ADD . $generic_batch_job