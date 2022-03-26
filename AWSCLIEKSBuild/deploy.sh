

admin_menu (){
    source EKS_functions.sh
    source EKS_Vars.sh

    local PS3='Please enter option: '
    local options=("Create EKS Cluster" "Create NodeGroup" "Delete EKS NodeGroup" "Delete EKS Cluster" "Connect to EKS Cluster" "Quit menu")
    local option
    select opt in "${options[@]}"
    do
        case $opt in
            "Create EKS Cluster")
                EKS_Create
                ;;
            "Create NodeGroup")
                EKS_node
                ;;
            "Delete EKS NodeGroup")
                NG_del
                ;;
            "Delete EKS Cluster")
                Cluster_DEL
                ;;
            "Connect to EKS Cluster")
                connect
                ;;
            "Quit Menu")
                return
                ;;
            *) echo "Invalid option $REPLY";;
        esac
    done
}

function cluster {

    function list_clusters {

    aws eks list-clusters --query clusters --output text

    }

    PS3="Select the source S3 bucket: "
    select EKS_Cluster in $(list_clusters);
    do
        if [ "x$EKS_Cluster" == "x" ]; then
            echo "You must select a valid bucket number." 1>&2
        else
            break
        fi
    done
}


admin_menu