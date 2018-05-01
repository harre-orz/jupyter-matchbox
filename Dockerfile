FROM jupyter/minimal-notebook

USER root
RUN apt-get update
RUN apt-get install -y iputils-ping ssh sshpass curl jq

USER jovyan
RUN conda install -y -c conda-forge jupyter_contrib_nbextensions
RUN pip install --upgrade pip setuptools ansible bash_kernel
RUN python -m bash_kernel.install

RUN pip install git+https://github.com/NII-cloud-operation/Jupyter-multi_outputs
RUN jupyter nbextension install lc_multi_outputs --user --py

USER root
COPY ansible.cfg /etc/ansible/ansible.cfg
RUN (echo "Cmnd_Alias ANSIBLES = /opt/conda/bin/ansible, /opt/conda/bin/ansible-playbook" \
 &&  echo "jovyan ALL=(ALL:ALL) NOPASSWD: ANSIBLES") >> /etc/sudoers

USER jovyan
RUN jupyter nbextension enable lc_multi_outputs --user --py
