#!/usr/bin/env bash

###############################################################################
# DevOps Tools Installation
# Docker, Kubernetes, Terraform, AWS CLI, etc.
###############################################################################

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

install_devops_tools() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Installing DevOps tools via Homebrew..."

        # Docker
        brew install --formula docker docker-completion
        brew install --cask docker 2>/dev/null || print_info "Docker Desktop may require manual installation"

        # Terraform ecosystem
        brew install --formula \
            terraform \
            terragrunt \
            tfenv

        # AWS
        brew install --formula awscli

        # Kubernetes tools
        brew install --formula \
            kubectl \
            helm

        # GitLab
        brew install --formula glab

        # Monitoring & Testing
        brew install --formula \
            nmap \
            tcpdump \
            iperf3

        # Additional DevOps tools
        brew install --formula \
            opentofu \
            ansible 2>/dev/null || true

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "Installing DevOps tools..."

        # Docker
        if ! command_exists docker; then
            print_info "Installing Docker..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh

            # Add user to docker group with security warning
            print_warning "SECURITY: Adding user to docker group grants effective root privileges"
            print_info "Users in docker group can run containers with root access to the host"

            if is_interactive; then
                read -p "Add $USER to docker group? (Y/n) " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                    sudo usermod -aG docker "$USER"
                    print_success "User added to docker group (logout/login required to take effect)"
                else
                    print_info "Skipped docker group addition (you'll need sudo for docker commands)"
                fi
            else
                # Non-interactive mode: add to group automatically
                sudo usermod -aG docker "$USER"
                print_info "User added to docker group (non-interactive mode)"
            fi

            rm get-docker.sh
        fi

        # Use Homebrew for other tools
        if command_exists brew; then
            brew install \
                terraform \
                terragrunt \
                awscli \
                kubectl \
                helm \
                glab \
                nmap
        else
            # Terraform
            if ! command_exists terraform; then
                print_info "Installing Terraform..."

                # Validate lsb_release output to prevent command injection
                DISTRO_CODENAME=$(lsb_release -cs 2>/dev/null)
                case "$DISTRO_CODENAME" in
                    focal|jammy|noble|mantic|lunar|kinetic|impish|hirsute|groovy|bullseye|bookworm|buster|trixie)
                        # Valid Ubuntu/Debian codename, proceed
                        ;;
                    *)
                        print_error "Unknown or unsupported distribution codename: $DISTRO_CODENAME"
                        print_info "Skipping Terraform installation"
                        return
                        ;;
                esac

                wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $DISTRO_CODENAME main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                sudo apt-get update && sudo apt-get install -y terraform
            fi

            # AWS CLI
            if ! command_exists aws; then
                print_info "Installing AWS CLI..."
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                unzip awscliv2.zip
                sudo ./aws/install
                rm -rf aws awscliv2.zip
            fi

            # kubectl
            if ! command_exists kubectl; then
                print_info "Installing kubectl..."
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
                rm kubectl
            fi
        fi
    fi

    print_success "DevOps tools installed"
}

# Main execution
main() {
    install_devops_tools
}

main "$@"
