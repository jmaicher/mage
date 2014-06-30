class API::NotesController < API::ApplicationController
  before_filter :authenticate_from_token!
  before_filter :attachable_filter, only: [:create]
  before_filter :context_filter, only: [:create]

  def index
    notes = Note.all
    coll = API::Collection.new(notes, self: api_notes_url)
    
    render json: CollectionRepresenter.new(coll)
  end # index

  def create
    note = Note.new(note_params)
    
    unless(image_param[:image_base64].nil?)
      note.image = process_image(image_param[:image_base64])
    end

    if is_attachment?
      note.attachable = @attachable
    end

    note.author = current_user

    if note.save
      response = ::NoteRepresenter.new(note)
      current_user.create_activity! "note.create", object: note, context: @context
      status = :created
    else
      response = note.errors
      status = :unprocessable_entity
    end

    render json: response, status: status
  end # create

private

  def note_params
    params.permit(:title, :description)
  end

  def image_param
    params.permit(:image_base64)
  end

  def attachable_param
    params.permit(:backlog_item_id)
  end

  def process_image(image_base64)
    image = parse_base64_image(image_base64)
    puts image[:data][0..10]

    tempfile = Tempfile.new ['attachment', image[:ext]]
    tempfile.binmode
    tempfile.write(Base64.decode64(image[:data])) 

    ActionDispatch::Http::UploadedFile.new(
      tempfile: tempfile,
      filename: "attachment.#{image[:ext]}"
    )
  end

  def parse_base64_image(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
      return {
        type:      $1, # "image/png"
        encoder:   $2, # "base64"
        data:      $3, # data string
        ext:       $1.split('/')[1] # "png"
        }
    end
  end

  def attachable_filter
    backlog_item_id = attachable_param[:backlog_item_id]
    unless backlog_item_id.nil?
      @attachable = BacklogItem.find(backlog_item_id)
    end
  end

  def is_attachment?
    !@attachable.nil?
  end

end # API::NotesController
