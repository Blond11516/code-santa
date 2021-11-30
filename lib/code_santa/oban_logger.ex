defmodule CodeSanta.ObanLogger do
  require Logger

  def handle_event([:oban, :job, :start], measure, meta, _) do
    Logger.info("[Oban] started #{meta.worker} at #{measure.system_time}")
  end

  def handle_event([:oban, :job, :stop], measure, meta, _) do
    Logger.info("[Oban] finished #{meta.worker} in #{measure.duration}")
  end

  def handle_event([:oban, :job, :exception], measure, meta, _) do
    Logger.error("[Oban] failed #{meta.worker} ran in #{measure.duration}: #{meta.reason}")
  end
end
