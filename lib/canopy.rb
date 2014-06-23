class Canopy
  ## Algorighm: Canopy Clustering
  # S = set of all points
  # T1, T2 = distance thresholds such that T1 > T2
  # Pick a point A at random from S i.e. A = S.pickRandom()
  #   this becomes a new canopy cluster center
  # For each of the points P in S: 
  #   if ( distance(A,P) > T1 ) ignore P else if ( distance(A,P) <= T1 ) select P
  #   if ( distance(A,P) < T2) then S.remove(P)
  # Repeat 2-3 steps until S is empty
  def initialize(distance_metric, t1, t2, points)
    @dm = distance_metric
    @T1 = t1
    @T2 = t2
    @points = points
    @canopies = []
  end

  def run
    canopies = []
    rem_points = (0...@points.length).to_a
    while rem_points.length > 0

      ## assume this is the canopy center C
      this_canopy = {
        intra_cluster_distance: 0.0,
        points: []
      }
      rem_points.shuffle!
      cc = rem_points.shift

      this_canopy[:points].push(cc) ## add as canopy center
      canopies.push(this_canopy) ## add to canopies

      ## iterate over remaining points
      all_points_distance = 0.0
      total_points = rem_points.length
      rem_points.each do |rp|
        vec_cc = @points[cc]
        vec_rp = @points[rp]
        dist = @dm.distance(vec_cc, vec_rp)
        all_points_distance += dist
        if dist <= @T1
          # add to canopy C
          if dist < @T2
            # remove for list of remaining points
            this_canopy[:points].push(rp)
            rem_points.delete(rp)
          end
        end
      end
      this_canopy[:intra_cluster_distance] = if total_points > 0
                                               all_points_distance / total_points
                                             else 0 end
    end
    @canopies = canopies
  end
  
end
