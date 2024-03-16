class_name CH

static func Query(shape: RID, transform: Transform2D, collisionmask, exclude):
    var query = PhysicsShapeQueryParameters2D.new()
    query.shape_rid = shape
    query.transform = transform
    query.collide_with_areas = true
    query.collide_with_bodies = false
    query.collision_mask = collisionmask
    query.exclude = [exclude]
    return exclude.get_world_2d().direct_space_state.intersect_shape(query)