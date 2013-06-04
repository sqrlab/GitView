require 'mysql'

module Stats_db
    require_relative 'utility'

    DATABASE = 'project_stats'
    HOST = 'localhost'
    USERNAME = 'git_miner'
    PASSWORD = 'pickaxe'

    #Tables:
    REPO = 'repositories'
    COMMITS = 'commits'
    FILE = 'file'

    # Repo
    REPO_ID = 'repo_id'
    REPO_NAME = 'repo_name'
    REPO_OWNER = 'repo_owner'

    # Commits
    COMMIT_ID = 'commit_id'
    REPO_REFERENCE ='repo_reference'
    COMMIT_DATE = 'commit_date'
    BODY = 'body'
    TOTAL_COMMENTS = 'total_comments'
    TOTAL_CODE = 'total_code'

    # File
    FILE_ID = 'file_id'
    COMMIT_REFERENCE = 'commit_reference'
    NAME = 'name'
    NUM_COMMENTS = 'num_comments'
    NUM_CODE = 'num_code'

    def Stats_db.createConnection()
        Mysql.new(HOST, USERNAME, PASSWORD, DATABASE)
    end


    # Get the repository's id stored in the database with the given name
    # Params:
    # +con+:: the database connection used. 
    # +name+:: the name of the repository
    def Stats_db.getRepoId(con, name, owner)
        pick = con.prepare("SELECT #{REPO_ID} FROM #{REPO} WHERE #{REPO_NAME} LIKE ? AND #{REPO_OWNER} LIKE ?")
        pick.execute(name, owner)
    
        result = pick.fetch
    
        if(result == nil)
            result = insertRepo(con, name, owner)
        end
        #There should be only 1 id return anyways.
        return Utility.toInteger(result)
    end    

    # Insert the given repository to the database
    # +con+:: the database connection used. 
    # +repo+:: the name of the repository
    def Stats_db.insertRepo(con, repo, owner)
        pick = con.prepare("INSERT INTO #{REPO} (#{REPO_NAME}, #{REPO_OWNER}) VALUES (?, ?)")
        pick.execute(repo, owner)

        return Utility.toInteger(pick.insert_id)
    end

    # Get all the commits stored in the database
    # Params:
    # +con+:: the database connection used. 
    def Stats_db.getCommits(con)
        pick = con.prepare("SELECT * FROM #{COMMITS}")
        pick.execute

        rows = pick.num_rows
        results = Array.new(rows)

        rows.times do |x|
            results[x] = pick.fetch
        end

        #results.each { |x| puts x }
        return results
    end

    # Insert the given commits to the database
    # +con+:: the database connection used. 
    # +repo_name+:: the name of the repository
    # +date+:: the date the commit was committed
    # +body+:: the commit message
    # +comments+:: the number of lines of comments in the commit
    # +code+:: the number of lines of code in the commit
    def Stats_db.insertCommit(con, repo_id, date, body, comments, code)

        pick = con.prepare("INSERT INTO #{COMMITS} (#{REPO_REFERENCE}, #{COMMIT_DATE}, #{BODY}, #{TOTAL_COMMENTS}, #{TOTAL_CODE}) VALUES (?, ?, ?, ?, ?)")
        pick.execute(repo_id, date, body, comments, code)

        return Utility.toInteger(pick.insert_id)
    end

    # Update the given commits to the database
    # +con+:: the database connection used. 
    # +repo_name+:: the name of the repository
    # +commiter+:: the +User+ that committed the commit
    # +author+:: the +User+ that wrote the code that is part of this commit
    # +body+:: the commit message
    # +sha+:: the uuid for the commit
    def Stats_db.updateCommit(con, commit_id, comments, code)

        pick = con.prepare("UPDATE #{COMMITS} SET #{TOTAL_COMMENTS}=?, #{TOTAL_CODE}=? WHERE #{COMMIT_ID} = ?")
        pick.execute(comments, code, commit_id)

        nil
        #return Utility.toInteger(commit_id)
    end

    def Stats_db.getFiles(con)
        pick = con.prepare("SELECT * FROM #{FILE}")
        pick.execute

        rows = pick.num_rows
        results = Array.new(rows)

        rows.times do |x|
            results[x] = pick.fetch
        end

        #results.each { |x| puts x }
        return results
    end

    def Stats_db.insertFile(con, commit_id, name, num_comments, num_code)

        pick = con.prepare("INSERT INTO #{FILE} (#{COMMIT_REFERENCE}, #{NAME}, #{NUM_COMMENTS}, #{NUM_CODE}) VALUES (?, ?, ?, ?)")
        pick.execute(commit_id, name, num_comments, num_code)

        return Utility.toInteger(pick.insert_id)
    end
end