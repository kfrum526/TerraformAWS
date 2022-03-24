source EKS_Creation.sh

admin_menu (){
    local PS3='Please enter option: '
    local options=("Create EKS Cluster" "Create NodeGroup" "Delete EKS Cluster" "Delete NodeGroup" "Connect to EKS Cluster" "Quit menu")
    local option
    select opt in "${options[@]}"
    do
        case $opt in
            "Create EKS Cluster")
                EKS_Create
                ;;
            "Create NodeGroup")
                ## Insert create nodegroup functoin here
                ;;
            "Delete EKS NodeGroup")
                ## Insert delete EKS NodeGroup here
                ;;
            "Delete EKS Cluster")
                ## Insert delete EKS cluster here
                ;;
            "Connect to EKS Cluster")
                ## Insert EKS connect function here
                ;;
            "Quit Menu")
                return
                ;;
            *) echo "Invalid option $REPLY";;
        esac
    done

}