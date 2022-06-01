FROM public.ecr.aws/lambda/python:3.9

COPY *.py ${LAMBDA_TASK_ROOT}
COPY requirements.txt ${LAMBDA_TASK_ROOT}

RUN pip3 install -r requirements.txt -t ${LAMBDA_TASK_ROOT}

CMD [ "rds_iam_auth.lambda_handler" ]