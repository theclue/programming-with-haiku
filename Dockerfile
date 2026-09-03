FROM pandoc/core:3.10.0-ubuntu
ENV TZ="Europe/Rome"
ENV PATH="/opt/pandoc-filter/bin:${PATH}"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    make tzdata calibre poppler-utils python3 python3-pip python3-venv \
    texlive-xetex texlive-fonts-extra texlive-fonts-recommended lmodern \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && python3 -c "import sys; assert (3, 10) <= sys.version_info < (3, 14), 'Python 3.10 <= version < 3.14 required'" \
  && python3 -m venv /opt/pandoc-filter \
  && /opt/pandoc-filter/bin/python -m pip install --no-cache-dir pandoc-latex-environment==1.2.1.0 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

WORKDIR /app
COPY . .

ENTRYPOINT []
CMD ["make", "all"]
