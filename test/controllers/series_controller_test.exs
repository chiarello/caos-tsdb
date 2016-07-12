defmodule ApiStorage.SeriesControllerTest do
  use ApiStorage.ConnCase

  alias ApiStorage.Series
  alias ApiStorage.Project
  alias ApiStorage.Metric
  @project %Project{id: "an id", name: "a name"}
  @metric %Metric{name: "a name", type: "a type"}

  @valid_attrs %{project_id: @project.id,
                 metric_name: @metric.name,
                 period: 3600,
                 ttl: 500}
  @series struct(Series, @valid_attrs)

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, series_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! @project
    metric = Repo.insert! @metric

    series = Repo.insert! @series
    conn = get conn, series_path(conn, :show, series)
    assert json_response(conn, 200)["data"] ==
      %{"id" => series.id,
        "project_id" => @series.project_id,
        "metric_name" => @series.metric_name,
        "period" => @series.period,
        "ttl" => @series.ttl,
        "last_timestamp"=> @series.last_timestamp}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, series_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    project = Repo.insert! @project
    metric = Repo.insert! @metric

    conn = post conn, series_path(conn, :create), series: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Series, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! @project
    metric = Repo.insert! @metric

    conn = post conn, series_path(conn, :create), series: %{@valid_attrs | project_id: "another"}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project = Repo.insert! @project
    metric = Repo.insert! @metric
    series = Repo.insert! @series

    conn = put conn, series_path(conn, :update, series), series: %{ttl: 3}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Series, %{ttl: 3})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! @project
    metric = Repo.insert! @metric
    series = Repo.insert! @series

    conn = put conn, series_path(conn, :update, series), series: %{ttl: "a string"}
    assert json_response(conn, 422)["errors"] != %{}
  end
end