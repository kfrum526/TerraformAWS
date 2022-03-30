

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

admin_menu