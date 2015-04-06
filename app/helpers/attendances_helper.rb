module AttendancesHelper
  def attended(attendance, person_id, session_id)
    if attendance[person_id] && attendance[person_id][session_id]
      true
    else
      false
    end
  end
end
