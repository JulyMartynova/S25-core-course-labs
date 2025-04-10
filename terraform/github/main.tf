terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = var.token
}

resource "github_repository" "new_repo" {
  name               = var.repo_name
  description        = "Soft arch"
  visibility         = var.repo_visibility
  has_issues         = true
  has_wiki           = true
  auto_init          = true
  license_template   = "apache"
  gitignore_template = "VisualStudio"
}

resource "github_branch_default" "master" {
  repository = github_repository.new_repo.name
  branch     = "master"
}

resource "github_branch_protection" "default" {
  repository_id                   = github_repository.new_repo.id
  pattern                         = github_branch_default.master.branch
  require_conversation_resolution = true
  enforce_admins                  = true

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
}
