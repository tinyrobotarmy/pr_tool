defmodule PrTool.GitReposTest do
  use PrTool.DataCase

  alias PrTool.GitRepos

  describe "git_repos" do
    alias PrTool.GitRepos.GitRepo

    @update_attrs %{name: "some updated name", url: "some updated url"}
    @invalid_attrs %{name: nil, url: nil}

    def git_repo_fixture(attrs \\ %{}) do
      Factory.create_git_repo(attrs)
    end

    test "list_git_repos/0 returns all git_repos" do
      git_repo = git_repo_fixture()
      assert Enum.count(GitRepos.list_git_repos()) == 1
    end

    test "get_git_repo!/1 returns the git_repo with given id" do
      git_repo = git_repo_fixture()
      assert GitRepos.get_git_repo!(git_repo.id).id == git_repo.id
    end

    test "create_git_repo/1 with valid data creates a git_repo" do
      attrs = Factory.all_git_repo_attributes()
      assert {:ok, %GitRepo{} = git_repo} = GitRepos.create_git_repo(attrs)
      assert git_repo.name == attrs["name"]
      assert git_repo.url == attrs["url"]
    end

    test "create_git_repo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GitRepos.create_git_repo(@invalid_attrs)
    end

    test "update_git_repo/2 with valid data updates the git_repo" do
      git_repo = git_repo_fixture()
      attrs = Factory.all_git_repo_attributes()
      assert {:ok, %GitRepo{} = git_repo} = GitRepos.update_git_repo(git_repo, attrs)
      assert git_repo.name == attrs["name"]
      assert git_repo.url == attrs["url"]
    end

    test "update_git_repo/2 with invalid data returns error changeset" do
      git_repo = git_repo_fixture()
      assert {:error, %Ecto.Changeset{}} = GitRepos.update_git_repo(git_repo, @invalid_attrs)
      assert git_repo.id == GitRepos.get_git_repo!(git_repo.id).id
    end

    test "delete_git_repo/1 deletes the git_repo" do
      git_repo = git_repo_fixture()
      assert {:ok, %GitRepo{}} = GitRepos.delete_git_repo(git_repo)
      assert_raise Ecto.NoResultsError, fn -> GitRepos.get_git_repo!(git_repo.id) end
    end

    test "change_git_repo/1 returns a git_repo changeset" do
      git_repo = git_repo_fixture()
      assert %Ecto.Changeset{} = GitRepos.change_git_repo(git_repo)
    end
  end
end
