#!/bin/sh
#
# Nom du developpeur : NSA
# Date de creation   : 2020/07/15
# Description        : Vérification des fichiers d'extraction afin de "neutraliser" si besoin les imports EDEAL
# -------------------------------------------------------------------------------------------------------------
#  
# -------------------------------------------------------------------------------------------------------------

function showHelp() {
  echo -e "Usage:\n$0 [OPTIONS]"
  echo -e "\nOptions générales :"
  echo -e "  --app-name [aco|asm|cnm|mba]"
  echo -e "      indique le nom de l'application"
  echo -e "  -h, --help"
  echo -e "      affiche cette aide"
}

######################
# Lecture des params #
######################
if [[ $1 == "--app-name" ]]; then
  APP_NAME="$2"

  case $APP_NAME in
    aco)
      CMROC=9931
      break
      ;;
    asm)
      CMROC=4631
      break
      ;;
    cnm)
      CMROC=9929
      break
      ;;
    mba)
      CMROC=9970
      break
      ;;
    *)
      showHelp
	  exit 1
      ;;
  esac
else
  showHelp
  exit
fi

# PARAMETRES
DATLCT=`date "+%Y%m%d"`
EXTRACT_PATH="/appli/edeal/tmp/tmp-files"
#EXTRACT_PATH="/appli/edeal/res/import/in_${CMROC}/update_files"
SCRIPT_SUPP_EXTRACT_FILES="/appli/edeal/tmp/SCRIPTS/supp_extract_files.sh"

echo -e "========================================================================\n-->`date "+%d/%m/%Y %T"` => Vérification des fichiers d'extraction dans ${EXTRACT_PATH}.\n"

#
# quitte le programme et supprime les fichiers d'extractions afin de "neutraliser" les imports EDEAL
#
function exitWithError() {
  echo -e "\n-----------------------------------------------------------------------------------------"
  echo "`date "+%d/%m/%Y %T"` => Erreur :: ${1}"
  eval "${SCRIPT_SUPP_EXTRACT_FILES} --app-name ${APP_NAME}"
  echo "--> Fin du programme de vérification avec erreur :: suppression des fichiers d'extraction"
  echo "-----------------------------------------------------------------------------------------"
  exit 1
}

function checkDataSize() {
  lignesErreurs=$(awk -F ";" -v champ=${1} -v maxlength=${2} 'length($champ)>maxlength {print NR}' ${EXTRACT_PATH}/${3}.csv)
  nbErreurs=$(echo -e "${lignesErreurs}\c" | wc -w)
  
  if [[ ${nbErreurs} -gt 0 ]]; then
    echo -e "\n--> Il y a ${nbErreurs} lignes en erreurs dans le fichier ${EXTRACT_PATH}/${3}.csv concernant la longueur du champ de la colonne ${1} (champ ${4} plus grand que ${2} caractères).\n"
	if [[ ${nbErreurs} -lt 20 ]]; then
	  echo -e "--> Les lignes en erreurs sont : $(echo ${lignesErreurs} | sed -e ':a;N;$!ba;s/\n/ /g')"
	fi
	exitWithError "Fichier ${EXTRACT_PATH}/${3}.csv"
  fi
}

#
# Vérifie que le fichier existe
#
function checkFileExist() {
  if [[ ! -e "${EXTRACT_PATH}/${1}.csv" ]]; then
    exitWithError "Le fichier ${EXTRACT_PATH}/${1}.csv n'existe pas."
  fi
}

function checkFileDataSize() {
  FILE_NAME=${1}
  
  case $FILE_NAME in
    PERSONNES_P_NOM_ADR | PERSONNES_P)
      # le champ "NOM" (col 5) doit avoir 30 caractères maximum
      checkDataSize 5 30 $FILE_NAME "NOM"
	  
      # le champ "PRENOM" (col 6) doit avoir 30 caractères maximum
      checkDataSize 6 30 $FILE_NAME "PRENOM"
	  
      # le champ "COMMUNE_NAISSANCE" (col 8) doit avoir 32 caractères maximum
      checkDataSize 8 32 $FILE_NAME "COMMUNE_NAISSANCE"
	  
      # le champ "ADRESSE1_PERSO" (col 19) doit avoir 50 caractères maximum
      checkDataSize 19 50 $FILE_NAME "ADRESSE1_PERSO"
	  
      # le champ "ADRESSE2_PERSO" (col 20) doit avoir 50 caractères maximum
      checkDataSize 20 50 $FILE_NAME "ADRESSE2_PERSO"
	  
      # le champ "ADRESSE3_PERSO" (col 21) doit avoir 150 caractères maximum
      checkDataSize 21 150 $FILE_NAME "ADRESSE3_PERSO"
	  
      # le champ "VILLE_PERSO" (col 22) doit avoir 32 caractères maximum
      checkDataSize 22 32 $FILE_NAME "VILLE_PERSO"
	  
      # le champ "MAIL_PERSO" (col 29) doit avoir 100 caractères maximum
      checkDataSize 29 100 $FILE_NAME "MAIL_PERSO"
	  
      # le champ "MAIL_PRO" (col 30) doit avoir 100 caractères maximum
      checkDataSize 30 100 $FILE_NAME "MAIL_PRO"
      ;;
	ENTREPRISES.csv)
      # le champ "RAISON_SOC" (col 6) doit avoir 100 caractères maximum
      checkDataSize 6 100 $FILE_NAME "RAISON_SOC"
	  
      # le champ "NOM_COMMERCIAL" (col 7) doit avoir 100 caractères maximum
      checkDataSize 7 100 $FILE_NAME "NOM_COMMERCIAL"
	  
      # le champ "AD1" (col 12) doit avoir 100 caractères maximum
      checkDataSize 12 100 $FILE_NAME "AD1"
	  
      # le champ "AD2" (col 13) doit avoir 50 caractères maximum
      checkDataSize 13 50 $FILE_NAME "AD2"
	  
      # le champ "AD3" (col 14) doit avoir 150 caractères maximum
      checkDataSize 14 150 $FILE_NAME "AD3"
	  
      # le champ "VILLE" (col 16) doit avoir 32 caractères maximum
      checkDataSize 16 32 $FILE_NAME "VILLE"
	  
      # le champ "EMAIL" (col 19) doit avoir 100 caractères maximum
      checkDataSize 19 100 $FILE_NAME "EMAIL"
      ;;
  esac
}

#
# Vérifie que le fichier fait plus d'1 ligne :: pas pertinent puisque si pas de MAJ d'une personne par exemple alors cela annule tout.
#
function checkFileSize() {
  nbLignes=$(wc -l < ${EXTRACT_PATH}/${1}.csv)

  if [[ ${nbLignes} -le 1 ]]; then
    exitWithError "Le fichier ${EXTRACT_PATH}/${1}.csv est trop petit (0 ou 1 ligne)."
  fi
}

#
# Parcours et vérification des fichiers d'extraction.
#
for file in \
CONTRATS_IND \
CONTRATS_COL \
ENTREPRISES \
PERSONNES_P \
PERSONNES_P_NOM_ADR \
LIENS_CONTRATS_PP \
LIENS_CONTRATS_PP_GARPACK \
LIENS_CONTRATS_ENTREPRISES \
LIENS_CONTRATS_PM_GARPACK
do
  # Vérification que le fichier existe : si un des fichiers n'existe pas, on les supprime tous et on arrête le programme.
  checkFileExist "${file}"
  
  # Vérification de la taille de certains champs
  checkFileDataSize "${file}"
done

echo -e "========================================================================\n-->`date "+%d/%m/%Y %T"` => Fin de traitement de vérification des fichiers d'extraction.\n"
echo -e "-->`date "+%d/%m/%Y %T"` => Vérification OK => on garde les fichiers d'import.\n"
